import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/saved_cities_provider.dart';
import '../widgets/forecast_list.dart';
import '../widgets/temperature_chart.dart';
import '../config/app_theme.dart';
import '../utils/weather_image_helper.dart';

/// Home screen - Main screen displaying weather search and information
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Handle search when user submits city name
  void _searchWeather() {
    final cityName = _searchController.text.trim();
    if (cityName.isNotEmpty) {
      // Unfocus the search field
      _searchFocusNode.unfocus();

      // Fetch weather data
      context.read<WeatherProvider>().fetchWeather(cityName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent app bar to show gradient background
      appBar: AppBar(
        title: const Text('Smart Weather'),
        actions: [
          // Save/Unsave city button
          Consumer2<WeatherProvider, SavedCitiesProvider>(
            builder: (context, weatherProvider, savedCitiesProvider, child) {
              final cityName = weatherProvider.currentCity;
              if (cityName.isEmpty) return const SizedBox.shrink();

              final isSaved = savedCitiesProvider.isCitySaved(cityName);
              return IconButton(
                icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border),
                tooltip: isSaved ? 'Remove from favorites' : 'Add to favorites',
                onPressed: () async {
                  await savedCitiesProvider.toggleCity(cityName);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isSaved
                              ? '$cityName removed from favorites'
                              : '$cityName added to favorites',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      // Navigation drawer
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<WeatherProvider>().refreshWeather();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Search bar
              _buildSearchBar(),
              const SizedBox(height: 16),
              // Main content based on state
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build search bar widget
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: 'Search for a city...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _searchWeather(),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  /// Build main content based on current state
  Widget _buildContent() {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        // Show loading indicator
        if (weatherProvider.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(64.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Show error message
        if (weatherProvider.errorMessage != null) {
          return _buildErrorMessage(weatherProvider.errorMessage!);
        }

        // Show weather data if available
        if (weatherProvider.currentWeather != null) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                _buildCurrentWeather(),
                const SizedBox(height: 24),
                _buildForecastSection(),
                const SizedBox(height: 24),
                _buildChartSection(),
                const SizedBox(height: 8),
              ],
            ),
          );
        }

        // Show welcome message
        return _buildWelcomeMessage();
      },
    );
  }

  /// Build welcome message when no data is loaded
  Widget _buildWelcomeMessage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wb_sunny_outlined,
            size: 120,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to Smart Weather',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Search for a city to see its weather forecast',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build error message widget
  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops!',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<WeatherProvider>().clearError();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  /// Build current weather card
  Widget _buildCurrentWeather() {
    final weatherProvider = context.watch<WeatherProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final weather = weatherProvider.currentWeather!;

    // Get temperature in correct unit
    final temp = settingsProvider.isCelsius
        ? weather.tempCelsius
        : weather.tempFahrenheit;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppTheme.darkCardGradient
              : AppTheme.lightCardGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // City name
              Text(
                weather.cityName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              // Weather description
              Text(
                weather.description.toUpperCase(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 24),
              // Weather icon and temperature
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Custom weather image based on condition
                  Image.asset(
                    WeatherImageHelper.getWeatherImage(
                      weather.condition,
                      weather.icon,
                    ),
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 24),
                  Text(
                    '${temp.round()}°',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 70,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Weather details (humidity, wind speed)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWeatherDetail(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: '${weather.humidity}%',
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  _buildWeatherDetail(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build weather detail item (humidity, wind speed)
  Widget _buildWeatherDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  /// Build forecast section
  Widget _buildForecastSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '7-Day Forecast',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 12),
        const ForecastList(),
      ],
    );
  }

  /// Build chart section
  Widget _buildChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Temperature Trend',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 12),
        const TemperatureChart(),
      ],
    );
  }

  /// Build navigation drawer
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.darkCardGradient
                  : AppTheme.lightCardGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.wb_sunny,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  'Smart Weather',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Saved Cities'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/saved_cities');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
    );
  }
}
