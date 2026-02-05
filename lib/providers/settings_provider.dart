import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider class to manage app settings
/// Handles temperature unit (Celsius/Fahrenheit) and theme mode (Light/Dark)
class SettingsProvider with ChangeNotifier {
  // Keys for storing settings in SharedPreferences
  static const String _keyTempUnit = 'temperature_unit';
  static const String _keyThemeMode = 'theme_mode';

  // State variables
  bool _isCelsius = true; // Default to Celsius
  ThemeMode _themeMode = ThemeMode.system; // Default to system theme

  // Getters
  bool get isCelsius => _isCelsius;
  bool get isFahrenheit => !_isCelsius;
  ThemeMode get themeMode => _themeMode;
  String get temperatureUnit => _isCelsius ? '°C' : '°F';

  /// Initialize settings from SharedPreferences
  /// Call this when the app starts
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load temperature unit (true = Celsius, false = Fahrenheit)
    _isCelsius = prefs.getBool(_keyTempUnit) ?? true;

    // Load theme mode (0 = system, 1 = light, 2 = dark)
    final themeModeIndex = prefs.getInt(_keyThemeMode) ?? 0;
    _themeMode = ThemeMode.values[themeModeIndex];

    notifyListeners();
  }

  /// Toggle between Celsius and Fahrenheit
  Future<void> toggleTemperatureUnit() async {
    _isCelsius = !_isCelsius;
    notifyListeners();

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTempUnit, _isCelsius);
  }

  /// Set temperature unit explicitly
  Future<void> setTemperatureUnit(bool celsius) async {
    if (_isCelsius != celsius) {
      _isCelsius = celsius;
      notifyListeners();

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyTempUnit, _isCelsius);
    }
  }

  /// Change theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyThemeMode, mode.index);
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Format temperature based on current unit setting
  String formatTemperature(double celsius) {
    if (_isCelsius) {
      return '${celsius.round()}°C';
    } else {
      final fahrenheit = (celsius * 9 / 5) + 32;
      return '${fahrenheit.round()}°F';
    }
  }

  /// Get temperature value in current unit
  double getTemperatureValue(double celsius) {
    if (_isCelsius) {
      return celsius;
    } else {
      return (celsius * 9 / 5) + 32;
    }
  }
}
