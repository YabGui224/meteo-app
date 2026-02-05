import 'package:flutter/material.dart';

/// Elegant theme configuration for the Smart Weather app
/// Uses Material 3 design with weather-inspired colors
class AppTheme {
  // Sky-inspired colors for light theme
  static const Color _lightPrimary = Color(0xFF1E88E5); // Bright sky blue
  static const Color _lightSecondary = Color(0xFF42A5F5); // Light blue
  static const Color _lightBackground = Color(0xFFF5F9FF); // Very light blue-white
  static const Color _lightSurface = Color(0xFFFFFFFF); // Pure white
  static const Color _lightCardGradientStart = Color(0xFF64B5F6); // Light blue
  static const Color _lightCardGradientEnd = Color(0xFF2196F3); // Medium blue

  // Night sky-inspired colors for dark theme
  static const Color _darkPrimary = Color(0xFF42A5F5); // Soft blue
  static const Color _darkSecondary = Color(0xFF90CAF9); // Light blue
  static const Color _darkBackground = Color(0xFF0A1929); // Deep navy
  static const Color _darkSurface = Color(0xFF132F4C); // Dark blue-gray
  static const Color _darkCardGradientStart = Color(0xFF1E3A5F); // Dark blue
  static const Color _darkCardGradientEnd = Color(0xFF2C5282); // Medium dark blue

  /// Light theme - Day mode with bright, airy colors
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: ColorScheme.light(
        primary: _lightPrimary,
        secondary: _lightSecondary,
        surface: _lightSurface,
        error: const Color(0xFFD32F2F),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF1A1C1E),
        onError: Colors.white,
      ).copyWith(surface: _lightBackground),

      // App bar theme
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1A1C1E),
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1C1E),
        ),
      ),

      // Card theme - elevated cards with subtle shadows
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: _lightSurface,
        shadowColor: Colors.black.withValues(alpha: 0.1),
      ),

      // Input decoration theme for search box
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _lightPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: _lightPrimary,
        size: 24,
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.w300,
          color: Color(0xFF1A1C1E),
        ),
        displayMedium: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1A1C1E),
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1C1E),
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1C1E),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF49454F),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF49454F),
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Drawer theme
      drawerTheme: DrawerThemeData(
        backgroundColor: _lightSurface,
        elevation: 16,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  /// Dark theme - Night mode with deep, atmospheric colors
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: _darkPrimary,
        secondary: _darkSecondary,
        surface: _darkSurface,
        error: const Color(0xFFEF5350),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ).copyWith(surface: _darkBackground),

      // App bar theme
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // Card theme - elevated cards with subtle glows
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: _darkSurface,
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),

      // Input decoration theme for search box
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _darkPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: _darkSecondary,
        size: 24,
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFFCAC4D0),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFFCAC4D0),
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Drawer theme
      drawerTheme: DrawerThemeData(
        backgroundColor: _darkSurface,
        elevation: 16,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  /// Gradient for weather cards in light theme
  static const LinearGradient lightCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_lightCardGradientStart, _lightCardGradientEnd],
  );

  /// Gradient for weather cards in dark theme
  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_darkCardGradientStart, _darkCardGradientEnd],
  );
}
