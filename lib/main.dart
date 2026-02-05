import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'providers/weather_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/saved_cities_provider.dart';
import 'screens/home_screen.dart';
import 'screens/saved_cities_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_screen.dart';

/// Main entry point of the Smart Weather application
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Create instances of providers
  final settingsProvider = SettingsProvider();
  final savedCitiesProvider = SavedCitiesProvider();

  // Load saved settings and cities
  await Future.wait([
    settingsProvider.loadSettings(),
    savedCitiesProvider.loadCities(),
  ]);

  // Run the app with providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: savedCitiesProvider),
      ],
      child: const SmartWeatherApp(),
    ),
  );
}

/// Main application widget
class SmartWeatherApp extends StatelessWidget {
  const SmartWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the settings provider to react to theme changes
    final settingsProvider = context.watch<SettingsProvider>();

    return MaterialApp(
      // App title
      title: 'Smart Weather',

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsProvider.themeMode,

      // Remove debug banner
      debugShowCheckedModeBanner: false,

      // Home screen
      home: const HomeScreen(),

      // Named routes for navigation
      routes: {
        '/saved_cities': (context) => const SavedCitiesScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
