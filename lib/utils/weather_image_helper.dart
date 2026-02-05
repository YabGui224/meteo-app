/// Helper class to map weather conditions to custom image assets
class WeatherImageHelper {
  /// Get the appropriate image asset path based on weather condition
  static String getWeatherImage(String condition, String iconCode) {
    final conditionLower = condition.toLowerCase();

    // Check for storm/thunderstorm
    if (conditionLower.contains('thunder') || conditionLower.contains('storm')) {
      return 'assets/storm.png';
    }

    // Check for rain/drizzle
    if (conditionLower.contains('rain') || conditionLower.contains('drizzle')) {
      return 'assets/rainy-day.png';
    }

    // Check for clouds
    if (conditionLower.contains('cloud') || conditionLower.contains('overcast')) {
      return 'assets/cloudy.png';
    }

    // Check for clear/sunny weather
    if (conditionLower.contains('clear') || conditionLower.contains('sun')) {
      return 'assets/sun.png';
    }

    // Fallback: use icon code to determine image
    // Icon codes: 01=clear, 02-04=clouds, 09-10=rain, 11=thunderstorm, 13=snow, 50=mist
    if (iconCode.startsWith('01')) {
      return 'assets/sun.png';
    } else if (iconCode.startsWith('02') || iconCode.startsWith('03') || iconCode.startsWith('04')) {
      return 'assets/cloudy.png';
    } else if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
      return 'assets/rainy-day.png';
    } else if (iconCode.startsWith('11')) {
      return 'assets/storm.png';
    } else if (iconCode.startsWith('50')) {
      return 'assets/cloudy.png'; // Mist/Fog uses cloudy image
    }

    // Default to sun for unknown conditions
    return 'assets/sun.png';
  }
}
