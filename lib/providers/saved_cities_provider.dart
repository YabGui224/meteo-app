import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider class to manage saved cities
/// Uses SharedPreferences to persist the list of cities
class SavedCitiesProvider with ChangeNotifier {
  // Key for storing cities in SharedPreferences
  static const String _keySavedCities = 'saved_cities';

  // State variable - list of saved city names
  List<String> _cities = [];

  // Getter
  List<String> get cities => List.unmodifiable(_cities);
  int get citiesCount => _cities.length;
  bool get hasNoCities => _cities.isEmpty;

  /// Initialize saved cities from SharedPreferences
  /// Call this when the app starts
  Future<void> loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    _cities = prefs.getStringList(_keySavedCities) ?? [];
    notifyListeners();
  }

  /// Save the current list of cities to SharedPreferences
  Future<void> _saveCities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keySavedCities, _cities);
  }

  /// Add a city to saved cities
  /// Returns true if added, false if already exists
  Future<bool> addCity(String cityName) async {
    // Normalize city name (trim and capitalize)
    final normalizedCity = _normalizeCity(cityName);

    // Check if city already exists (case-insensitive)
    if (_cities.any((city) => city.toLowerCase() == normalizedCity.toLowerCase())) {
      return false; // City already exists
    }

    // Add city to the list
    _cities.add(normalizedCity);
    notifyListeners();

    // Save to SharedPreferences
    await _saveCities();
    return true;
  }

  /// Remove a city from saved cities
  Future<void> removeCity(String cityName) async {
    _cities.removeWhere(
      (city) => city.toLowerCase() == cityName.toLowerCase(),
    );
    notifyListeners();

    // Save to SharedPreferences
    await _saveCities();
  }

  /// Check if a city is already saved
  bool isCitySaved(String cityName) {
    return _cities.any(
      (city) => city.toLowerCase() == cityName.toLowerCase(),
    );
  }

  /// Toggle city (add if not saved, remove if saved)
  Future<void> toggleCity(String cityName) async {
    if (isCitySaved(cityName)) {
      await removeCity(cityName);
    } else {
      await addCity(cityName);
    }
  }

  /// Clear all saved cities
  Future<void> clearAllCities() async {
    _cities.clear();
    notifyListeners();

    // Save to SharedPreferences
    await _saveCities();
  }

  /// Normalize city name (trim whitespace and capitalize first letter)
  String _normalizeCity(String cityName) {
    final trimmed = cityName.trim();
    if (trimmed.isEmpty) return trimmed;

    // Capitalize first letter of each word
    return trimmed.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
