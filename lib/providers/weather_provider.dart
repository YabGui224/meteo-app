import 'package:flutter/foundation.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';

/// Provider class to manage weather data state
/// Uses ChangeNotifier to notify widgets when data changes
class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  // State variables
  Weather? _currentWeather;
  Forecast? _forecast;
  bool _isLoading = false;
  String? _errorMessage;
  String _currentCity = '';

  // Getters to access state
  Weather? get currentWeather => _currentWeather;
  Forecast? get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentCity => _currentCity;

  /// Fetch weather data for a given city
  /// This method fetches both current weather and 7-day forecast
  Future<void> fetchWeather(String cityName) async {
    // Don't fetch if already loading
    if (_isLoading) return;

    // Clear previous error
    _errorMessage = null;

    // Set loading state
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch weather and forecast data
      final data = await _weatherService.getWeatherAndForecast(cityName);

      // Update state with fetched data
      _currentWeather = data['weather'] as Weather;
      _forecast = data['forecast'] as Forecast;
      _currentCity = cityName;
      _errorMessage = null;
    } catch (e) {
      // Handle errors
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _currentWeather = null;
      _forecast = null;
    } finally {
      // Always set loading to false when done
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh current weather data
  Future<void> refreshWeather() async {
    if (_currentCity.isNotEmpty) {
      await fetchWeather(_currentCity);
    }
  }

  /// Clear all weather data
  void clearWeather() {
    _currentWeather = null;
    _forecast = null;
    _errorMessage = null;
    _currentCity = '';
    notifyListeners();
  }

  /// Clear only error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
