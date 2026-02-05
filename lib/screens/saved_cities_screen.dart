import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/saved_cities_provider.dart';
import '../providers/weather_provider.dart';

/// Screen displaying saved/favorite cities
/// Users can tap a city to load its weather, or delete cities they no longer want
class SavedCitiesScreen extends StatelessWidget {
  const SavedCitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Cities'),
        actions: [
          // Clear all button
          Consumer<SavedCitiesProvider>(
            builder: (context, provider, child) {
              if (provider.cities.isEmpty) return const SizedBox.shrink();

              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Clear all',
                onPressed: () => _showClearAllDialog(context),
              );
            },
          ),
        ],
      ),
      body: Consumer<SavedCitiesProvider>(
        builder: (context, savedCitiesProvider, child) {
          // Show empty state if no cities saved
          if (savedCitiesProvider.cities.isEmpty) {
            return _buildEmptyState(context);
          }

          // Show list of saved cities
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: savedCitiesProvider.cities.length,
            itemBuilder: (context, index) {
              final city = savedCitiesProvider.cities[index];
              return _buildCityCard(context, city, savedCitiesProvider);
            },
          );
        },
      ),
    );
  }

  /// Build empty state when no cities are saved
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 100,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No Saved Cities',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Search for a city on the home screen and tap the heart icon to save it here',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.home),
              label: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build city card
  Widget _buildCityCard(
    BuildContext context,
    String city,
    SavedCitiesProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            Icons.location_city,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: Text(
          city,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: const Text('Tap to view weather'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Theme.of(context).colorScheme.error,
          tooltip: 'Remove from favorites',
          onPressed: () => _showDeleteDialog(context, city, provider),
        ),
        onTap: () {
          // Load weather for this city and navigate back to home
          context.read<WeatherProvider>().fetchWeather(city);
          Navigator.pop(context);

          // Show snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Loading weather for $city...'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  /// Show confirmation dialog before deleting a city
  void _showDeleteDialog(
    BuildContext context,
    String city,
    SavedCitiesProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove City'),
        content: Text('Remove $city from your saved cities?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.removeCity(city);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$city removed from favorites'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Remove',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog before clearing all cities
  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Cities'),
        content: const Text(
          'Are you sure you want to remove all saved cities? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SavedCitiesProvider>().clearAllCities();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All cities removed'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Clear All',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
