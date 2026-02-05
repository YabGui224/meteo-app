import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

/// Custom widget to display weather icons based on condition
/// Maps OpenWeatherMap icon codes to appropriate weather icons
class WeatherIconWidget extends StatelessWidget {
  final String iconCode;
  final double size;
  final Color? color;

  const WeatherIconWidget({
    super.key,
    required this.iconCode,
    this.size = 64,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BoxedIcon(
      _getWeatherIcon(iconCode),
      size: size,
      color: color ?? Theme.of(context).iconTheme.color,
    );
  }

  /// Map OpenWeatherMap icon code to Weather Icons
  /// Icon codes: https://openweathermap.org/weather-conditions
  IconData _getWeatherIcon(String code) {
    switch (code) {
      // Clear sky
      case '01d':
        return WeatherIcons.day_sunny;
      case '01n':
        return WeatherIcons.night_clear;

      // Few clouds
      case '02d':
        return WeatherIcons.day_cloudy;
      case '02n':
        return WeatherIcons.night_alt_cloudy;

      // Scattered clouds
      case '03d':
      case '03n':
        return WeatherIcons.cloud;

      // Broken clouds
      case '04d':
      case '04n':
        return WeatherIcons.cloudy;

      // Shower rain
      case '09d':
        return WeatherIcons.day_showers;
      case '09n':
        return WeatherIcons.night_alt_showers;

      // Rain
      case '10d':
        return WeatherIcons.day_rain;
      case '10n':
        return WeatherIcons.night_alt_rain;

      // Thunderstorm
      case '11d':
        return WeatherIcons.day_thunderstorm;
      case '11n':
        return WeatherIcons.night_alt_thunderstorm;

      // Snow
      case '13d':
        return WeatherIcons.day_snow;
      case '13n':
        return WeatherIcons.night_alt_snow;

      // Mist/Fog
      case '50d':
        return WeatherIcons.day_fog;
      case '50n':
        return WeatherIcons.night_fog;

      // Default
      default:
        return WeatherIcons.na;
    }
  }
}

/// Get weather icon based on condition name (for forecast)
IconData getWeatherIconByCondition(String condition) {
  final conditionLower = condition.toLowerCase();

  if (conditionLower.contains('clear')) {
    return WeatherIcons.day_sunny;
  } else if (conditionLower.contains('cloud')) {
    return WeatherIcons.cloudy;
  } else if (conditionLower.contains('rain') || conditionLower.contains('drizzle')) {
    return WeatherIcons.rain;
  } else if (conditionLower.contains('thunder')) {
    return WeatherIcons.thunderstorm;
  } else if (conditionLower.contains('snow')) {
    return WeatherIcons.snow;
  } else if (conditionLower.contains('mist') ||
      conditionLower.contains('fog') ||
      conditionLower.contains('haze')) {
    return WeatherIcons.fog;
  } else if (conditionLower.contains('wind')) {
    return WeatherIcons.strong_wind;
  } else {
    return WeatherIcons.na;
  }
}
