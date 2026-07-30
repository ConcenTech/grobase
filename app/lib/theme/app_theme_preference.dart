/// User-selectable appearance preference (distinct from Flutter's [ThemeMode]).
enum AppThemePreference {
  /// Day/night follows the location's sunrise and sunset from weather data.
  location(
    label: 'Location',
    description: 'Matches sunrise and sunset at your system location',
  ),

  /// Follows the device system theme.
  device(label: 'Device', description: 'Matches your device setting'),

  /// Always light (daytime on the home screen).
  light(label: 'Light', description: 'Always light'),

  /// Always dark (nighttime on the home screen).
  dark(label: 'Dark', description: 'Always dark');

  final String label;
  final String description;

  const AppThemePreference({required this.label, required this.description});

  /// The default theme preference for the app.
  static AppThemePreference get appDefault => AppThemePreference.location;
}
