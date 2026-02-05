import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

/// Settings screen where users can configure app preferences
/// - Temperature unit (Celsius/Fahrenheit)
/// - Theme mode (Light/Dark/System)
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Temperature Unit Section
          _buildSectionHeader(context, 'Temperature Unit'),
          _buildTemperatureUnitSetting(context),
          const Divider(height: 32),

          // Theme Section
          _buildSectionHeader(context, 'Appearance'),
          _buildThemeSetting(context),
          const Divider(height: 32),

          // Info section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Changes are saved automatically',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Build section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  /// Build temperature unit setting
  Widget _buildTemperatureUnitSetting(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Column(
          children: [
            RadioListTile<bool>(
              title: const Text('Celsius (°C)'),
              subtitle: const Text('Metric system'),
              value: true,
              groupValue: settingsProvider.isCelsius,
              onChanged: (value) {
                if (value != null) {
                  settingsProvider.setTemperatureUnit(value);
                }
              },
              secondary: const Icon(Icons.thermostat),
            ),
            RadioListTile<bool>(
              title: const Text('Fahrenheit (°F)'),
              subtitle: const Text('Imperial system'),
              value: false,
              groupValue: settingsProvider.isCelsius,
              onChanged: (value) {
                if (value != null) {
                  settingsProvider.setTemperatureUnit(value);
                }
              },
              secondary: const Icon(Icons.thermostat),
            ),
          ],
        );
      },
    );
  }

  /// Build theme setting
  Widget _buildThemeSetting(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Column(
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              subtitle: const Text('Follow system settings'),
              value: ThemeMode.system,
              groupValue: settingsProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  settingsProvider.setThemeMode(value);
                }
              },
              secondary: const Icon(Icons.brightness_auto),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light Mode'),
              subtitle: const Text('Bright and sunny'),
              value: ThemeMode.light,
              groupValue: settingsProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  settingsProvider.setThemeMode(value);
                }
              },
              secondary: const Icon(Icons.light_mode),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark Mode'),
              subtitle: const Text('Easy on the eyes'),
              value: ThemeMode.dark,
              groupValue: settingsProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  settingsProvider.setThemeMode(value);
                }
              },
              secondary: const Icon(Icons.dark_mode),
            ),
          ],
        );
      },
    );
  }
}
