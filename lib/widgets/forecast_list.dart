import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/weather_icon.dart';

/// Horizontal scrollable list displaying 7-day forecast
class ForecastList extends StatelessWidget {
  const ForecastList({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();
    final forecast = weatherProvider.forecast;

    if (forecast == null || forecast.daily.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: forecast.daily.length,
        itemBuilder: (context, index) {
          final day = forecast.daily[index];
          return _ForecastCard(
            date: day.date,
            icon: day.icon,
            condition: day.condition,
            tempMin: day.tempMinCelsius,
            tempMax: day.tempMaxCelsius,
            isFirst: index == 0,
          );
        },
      ),
    );
  }
}

/// Individual forecast card for a single day
class _ForecastCard extends StatelessWidget {
  final DateTime date;
  final String icon;
  final String condition;
  final double tempMin;
  final double tempMax;
  final bool isFirst;

  const _ForecastCard({
    required this.date,
    required this.icon,
    required this.condition,
    required this.tempMin,
    required this.tempMax,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    // Format date
    final dayName = isFirst ? 'Today' : DateFormat('EEE').format(date);
    final dateStr = DateFormat('MMM d').format(date);

    // Get temperatures in correct unit
    final minTemp = settingsProvider.isCelsius
        ? tempMin
        : (tempMin * 9 / 5) + 32;
    final maxTemp = settingsProvider.isCelsius
        ? tempMax
        : (tempMax * 9 / 5) + 32;

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Day name
              Text(
                dayName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              // Date
              Text(
                dateStr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withOpacity(0.7),
                    ),
              ),
              const SizedBox(height: 8),
              // Weather icon
              WeatherIconWidget(
                iconCode: icon,
                size: 40,
              ),
              const SizedBox(height: 8),
              // Temperature range
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${maxTemp.round()}°',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    ' / ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '${minTemp.round()}°',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
