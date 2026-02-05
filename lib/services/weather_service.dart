import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';

/// Service class to interact with OpenWeatherMap API
class WeatherService {
  // TODO: Replace with your OpenWeatherMap API key
  // Get your free API key at: https://openweathermap.org/api
  static const String _apiKey = 'your-api_key';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Fetch current weather for a city
  /// Throws an exception if the city is not found or if there's a network error
  Future<Weather> getCurrentWeather(String cityName) async {
    // Validate city name
    if (cityName.trim().isEmpty) {
      throw Exception('Please enter a city name');
    }

    // Build the API URL
    final url = Uri.parse(
      '$_baseUrl/weather?q=$cityName&appid=$_apiKey',
    );

    try {
      // Make the HTTP request
      final response = await http.get(url);

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse JSON response
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else if (response.statusCode == 404) {
        // City not found
        throw Exception('City not found. Please check the spelling and try again.');
      } else if (response.statusCode == 401) {
        // Invalid API key
        throw Exception('API key error. Please check your OpenWeatherMap API key.');
      } else {
        // Other errors
        throw Exception('Failed to load weather data. Error: ${response.statusCode}');
      }
    } catch (e) {
      // Network error or other exceptions
      if (e.toString().contains('City not found') ||
          e.toString().contains('API key error') ||
          e.toString().contains('Please enter')) {
        rethrow;
      }
      throw Exception('Network error. Please check your internet connection.');
    }
  }

  /// Fetch 5-day/3-hour forecast for a city (FREE API)
  /// Processes the 3-hour interval data into daily forecasts
  /// Throws an exception if the city is not found or if there's a network error
  Future<Forecast> getForecast(String cityName) async {
    // Validate city name
    if (cityName.trim().isEmpty) {
      throw Exception('Please enter a city name');
    }

    // Build the API URL (using FREE 5-day/3-hour forecast endpoint)
    final url = Uri.parse(
      '$_baseUrl/forecast?q=$cityName&appid=$_apiKey',
    );

    try {
      // Make the HTTP request
      final response = await http.get(url);

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse JSON response
        final data = json.decode(response.body);

        // Process 3-hour data into daily forecasts
        return _processForecastData(data);
      } else if (response.statusCode == 404) {
        // City not found
        throw Exception('City not found. Please check the spelling and try again.');
      } else if (response.statusCode == 401) {
        // Invalid API key
        throw Exception('API key error. Please check your OpenWeatherMap API key.');
      } else {
        // Other errors
        throw Exception('Failed to load forecast data. Error: ${response.statusCode}');
      }
    } catch (e) {
      // Network error or other exceptions
      if (e.toString().contains('City not found') ||
          e.toString().contains('API key error') ||
          e.toString().contains('Please enter')) {
        rethrow;
      }
      throw Exception('Network error. Please check your internet connection.');
    }
  }

  /// Process 3-hour interval forecast data into daily forecasts
  Forecast _processForecastData(Map<String, dynamic> data) {
    final cityName = data['city']['name'] ?? '';
    final List<dynamic> forecastList = data['list'] ?? [];

    // Group forecasts by day
    final Map<String, List<Map<String, dynamic>>> dailyData = {};

    for (var item in forecastList) {
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(
        item['dt'] * 1000,
        isUtc: true,
      );
      final String dateKey = '${date.year}-${date.month}-${date.day}';

      if (!dailyData.containsKey(dateKey)) {
        dailyData[dateKey] = [];
      }
      dailyData[dateKey]!.add(item as Map<String, dynamic>);
    }

    // Convert grouped data into ForecastDay objects
    final List<ForecastDay> forecastDays = [];

    for (var entry in dailyData.entries) {
      final dayData = entry.value;
      if (dayData.isEmpty) continue;

      // Get date from first entry
      final DateTime date = DateTime.fromMillisecondsSinceEpoch(
        dayData[0]['dt'] * 1000,
        isUtc: true,
      );

      // Calculate min/max temps for the day
      double minTemp = double.infinity;
      double maxTemp = double.negativeInfinity;

      for (var item in dayData) {
        final temp = (item['main']['temp'] as num).toDouble();
        if (temp < minTemp) minTemp = temp;
        if (temp > maxTemp) maxTemp = temp;
      }

      // Use the middle entry for other data (or first if less than 3 entries)
      final middleIndex = dayData.length ~/ 2;
      final representativeData = dayData[middleIndex];

      final forecastDay = ForecastDay(
        date: date,
        tempMin: minTemp,
        tempMax: maxTemp,
        condition: representativeData['weather'][0]['main'] ?? '',
        description: representativeData['weather'][0]['description'] ?? '',
        icon: representativeData['weather'][0]['icon'] ?? '01d',
        humidity: representativeData['main']['humidity'] ?? 0,
        windSpeed: (representativeData['wind']['speed'] as num?)?.toDouble() ?? 0.0,
      );

      forecastDays.add(forecastDay);
    }

    // Sort by date and take up to 7 days
    forecastDays.sort((a, b) => a.date.compareTo(b.date));
    final limitedForecast = forecastDays.take(7).toList();

    return Forecast(
      cityName: cityName,
      daily: limitedForecast,
    );
  }

  /// Fetch both current weather and forecast for a city
  /// Returns a tuple-like map with 'weather' and 'forecast' keys
  Future<Map<String, dynamic>> getWeatherAndForecast(String cityName) async {
    try {
      // Fetch both in parallel for better performance
      final results = await Future.wait([
        getCurrentWeather(cityName),
        getForecast(cityName),
      ]);

      return {
        'weather': results[0] as Weather,
        'forecast': results[1] as Forecast,
      };
    } catch (e) {
      rethrow;
    }
  }
}
