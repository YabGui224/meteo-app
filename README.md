# Smart Weather ☀️

An elegant and modern Flutter weather application with beautiful Material 3 design. Get accurate weather forecasts, visualize temperature trends, and save your favorite cities.

## Features

✨ **Elegant Design**
- Beautiful Material 3 design with weather-inspired colors
- Smooth gradients and modern UI elements
- Light and dark theme support

🌍 **Weather Information**
- Search weather for any city worldwide
- Current weather conditions (temperature, humidity, wind speed)
- 7-day weather forecast
- Beautiful weather icons that match conditions

📊 **Visualizations**
- Interactive temperature trend chart
- Min/max temperature visualization
- Easy-to-read forecast cards

⭐ **Convenience Features**
- Save favorite cities for quick access
- Switch between Celsius and Fahrenheit
- Pull-to-refresh weather data
- Offline settings persistence


## Getting Started

### Prerequisites

- Flutter SDK (^3.10.1)
- Dart SDK
- An OpenWeatherMap API key (free)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd meteo_app_weather
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Get your OpenWeatherMap API key**
   - Go to [OpenWeatherMap](https://openweathermap.org/api)
   - Sign up for a free account
   - Navigate to API keys section
   - Copy your API key

4. **Add your API key**
   - Open `lib/services/weather_service.dart`
   - Replace `YOUR_API_KEY_HERE` with your actual API key:
   ```dart
   static const String _apiKey = 'your_actual_api_key_here';
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── config/
│   └── app_theme.dart          # Theme configuration
├── models/
│   ├── weather.dart            # Weather data model
│   └── forecast.dart           # Forecast data model
├── providers/
│   ├── weather_provider.dart   # Weather state management
│   ├── settings_provider.dart  # Settings state management
│   └── saved_cities_provider.dart # Saved cities management
├── screens/
│   ├── home_screen.dart        # Main weather screen
│   ├── saved_cities_screen.dart # Saved cities list
│   ├── settings_screen.dart    # App settings
│   └── about_screen.dart       # About app info
├── services/
│   └── weather_service.dart    # OpenWeatherMap API service
├── widgets/
│   ├── weather_icon.dart       # Weather icon widget
│   ├── forecast_list.dart      # 7-day forecast list
│   └── temperature_chart.dart  # Temperature chart
└── main.dart                   # App entry point
```

### API Integration
- Uses OpenWeatherMap API for weather data
- Current weather endpoint for real-time data
- Daily forecast endpoint for 7-day predictions
- Comprehensive error handling for network issues


## Dependencies

- **provider**: State management
- **http**: API requests
- **shared_preferences**: Local storage
- **fl_chart**: Beautiful charts
- **weather_icons**: Weather-specific icons
- **intl**: Date formatting

## Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Troubleshooting

### "City not found" error
- Check the spelling of the city name
- Try using the city name in English
- Some small towns may not be in the database

### "API key error"
- Make sure you've added your API key in `weather_service.dart`
- Verify your API key is active on OpenWeatherMap
- Free API keys may have rate limits

### "Network error"
- Check your internet connection
- Verify you're not behind a firewall blocking API requests

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Credits

- Weather data provided by [OpenWeatherMap](https://openweathermap.org/)
- Weather icons from [Weather Icons](https://pub.dev/packages/weather_icons)
- Built with [Flutter](https://flutter.dev/)

## Version

**Version 1.0.0** - Initial Release

---

Built with ❤️ using Flutter
