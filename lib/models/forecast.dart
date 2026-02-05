/// Model class to represent a single forecast item for a specific day
class ForecastDay {
  final DateTime date;
  final double tempMin; // Minimum temperature in Kelvin
  final double tempMax; // Maximum temperature in Kelvin
  final String condition; // Weather condition
  final String description;
  final String icon; // Icon code from OpenWeatherMap
  final int humidity;
  final double windSpeed;

  ForecastDay({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  /// Factory constructor to create ForecastDay from JSON
  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: DateTime.fromMillisecondsSinceEpoch(
        json['dt'] * 1000,
        isUtc: true,
      ),
      tempMin: (json['temp']['min'] as num).toDouble(),
      tempMax: (json['temp']['max'] as num).toDouble(),
      condition: json['weather'][0]['main'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '01d',
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['speed'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Get minimum temperature in Celsius
  double get tempMinCelsius => tempMin - 273.15;

  /// Get maximum temperature in Celsius
  double get tempMaxCelsius => tempMax - 273.15;

  /// Get minimum temperature in Fahrenheit
  double get tempMinFahrenheit => (tempMin - 273.15) * 9 / 5 + 32;

  /// Get maximum temperature in Fahrenheit
  double get tempMaxFahrenheit => (tempMax - 273.15) * 9 / 5 + 32;

  /// Get average temperature in Celsius
  double get tempAvgCelsius => (tempMinCelsius + tempMaxCelsius) / 2;

  /// Get average temperature in Fahrenheit
  double get tempAvgFahrenheit => (tempMinFahrenheit + tempMaxFahrenheit) / 2;
}

/// Model class to represent a 7-day forecast
class Forecast {
  final String cityName;
  final List<ForecastDay> daily;

  Forecast({
    required this.cityName,
    required this.daily,
  });

  /// Factory constructor to create Forecast from JSON
  factory Forecast.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dailyData = json['list'] ?? [];
    final List<ForecastDay> forecastDays = dailyData
        .take(7) // Take only 7 days
        .map((day) => ForecastDay.fromJson(day))
        .toList();

    return Forecast(
      cityName: json['city']['name'] ?? '',
      daily: forecastDays,
    );
  }
}
