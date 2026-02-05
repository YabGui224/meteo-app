// Basic Flutter widget test for Smart Weather app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_app_weather/main.dart';
import 'package:provider/provider.dart';
import 'package:meteo_app_weather/providers/weather_provider.dart';
import 'package:meteo_app_weather/providers/settings_provider.dart';
import 'package:meteo_app_weather/providers/saved_cities_provider.dart';

void main() {
  testWidgets('App starts and shows Smart Weather title', (WidgetTester tester) async {
    // Create mock providers
    final settingsProvider = SettingsProvider();
    final savedCitiesProvider = SavedCitiesProvider();

    // Build our app and trigger a frame
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => WeatherProvider()),
          ChangeNotifierProvider.value(value: settingsProvider),
          ChangeNotifierProvider.value(value: savedCitiesProvider),
        ],
        child: const SmartWeatherApp(),
      ),
    );

    // Verify that the app title appears
    expect(find.text('Smart Weather'), findsOneWidget);

    // Verify that the search box appears
    expect(find.byType(TextField), findsOneWidget);
  });
}
