/// Model class to represent current weather data
class Weather {
  final String cityName;
  final double temperature; // Temperature in Kelvin from API
  final String condition; // Weather condition (e.g., "Clear", "Rain")
  final String description; // Detailed description
  final String icon; // Icon code from OpenWeatherMap
  final int humidity; // Humidity percentage
  final double windSpeed; // Wind speed in m/s
  final DateTime dateTime; // Time of data calculation

  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.dateTime,
  });

  /// Factory constructor to create Weather object from JSON
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '01d',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        json['dt'] * 1000,
        isUtc: true,
      ),
    );
  }

  /// Get temperature in Celsius
  double get tempCelsius => temperature - 273.15;

  /// Get temperature in Fahrenheit
  double get tempFahrenheit => (temperature - 273.15) * 9 / 5 + 32;
}
