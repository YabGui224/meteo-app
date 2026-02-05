import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';

/// Line chart displaying temperature trend for 7 days
class TemperatureChart extends StatelessWidget {
  const TemperatureChart({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final forecast = weatherProvider.forecast;

    if (forecast == null || forecast.daily.isEmpty) {
      return const SizedBox.shrink();
    }

    // Prepare data for the chart
    final List<FlSpot> maxTempSpots = [];
    final List<FlSpot> minTempSpots = [];

    for (int i = 0; i < forecast.daily.length; i++) {
      final day = forecast.daily[i];
      final maxTemp = settingsProvider.isCelsius
          ? day.tempMaxCelsius
          : day.tempMaxFahrenheit;
      final minTemp = settingsProvider.isCelsius
          ? day.tempMinCelsius
          : day.tempMinFahrenheit;

      maxTempSpots.add(FlSpot(i.toDouble(), maxTemp));
      minTempSpots.add(FlSpot(i.toDouble(), minTemp));
    }

    // Calculate min and max for Y axis
    final allTemps = [...maxTempSpots, ...minTempSpots]
        .map((spot) => spot.y)
        .toList();
    final minY = allTemps.reduce((a, b) => a < b ? a : b) - 5;
    final maxY = allTemps.reduce((a, b) => a > b ? a : b) + 5;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Chart
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minY: minY,
                    maxY: maxY,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: (maxY - minY) / 4,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.1),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      // Bottom titles (days)
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() < forecast.daily.length) {
                              final date = forecast.daily[value.toInt()].date;
                              final dayName = value.toInt() == 0
                                  ? 'Today'
                                  : DateFormat('EEE').format(date);
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  dayName,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      // Left titles (temperature)
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: (maxY - minY) / 4,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.round()}°',
                              style: Theme.of(context).textTheme.bodySmall,
                            );
                          },
                        ),
                      ),
                      // Hide top and right titles
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      // Max temperature line (red/orange)
                      LineChartBarData(
                        spots: maxTempSpots,
                        isCurved: true,
                        color: Colors.orange,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.orange,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.orange.withOpacity(0.1),
                        ),
                      ),
                      // Min temperature line (blue)
                      LineChartBarData(
                        spots: minTempSpots,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.blue,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.1),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final unit = settingsProvider.temperatureUnit;
                            return LineTooltipItem(
                              '${spot.y.round()}$unit',
                              TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(
                    context,
                    color: Colors.orange,
                    label: 'Max Temp',
                  ),
                  const SizedBox(width: 24),
                  _buildLegendItem(
                    context,
                    color: Colors.blue,
                    label: 'Min Temp',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build legend item
  Widget _buildLegendItem(
    BuildContext context, {
    required Color color,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
