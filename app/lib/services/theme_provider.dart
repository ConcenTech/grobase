import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme_preference.dart';
import 'database/database_providers.dart';
import 'database/offline_storage.dart';
import 'weather/weather_providers.dart';

/// Persisted appearance preference.
final themePreferenceProvider =
    NotifierProvider<ThemePreferenceNotifier, AppThemePreference>(
      ThemePreferenceNotifier.new,
    );

class ThemePreferenceNotifier extends Notifier<AppThemePreference> {
  late final OfflineStorage _storage;

  @override
  AppThemePreference build() {
    _storage = ref.read(DatabaseProviders.offlineStorage);
    return _storage.getThemePreference();
  }

  void setPreference(AppThemePreference preference) {
    if (state == preference) return;
    state = preference;
    _storage.setThemePreference(preference);
  }
}

/// Completes after [wait] via a [Timer], invalidating dependents so location
/// theme can flip at the next sunrise/sunset.
final _dayNightBoundaryProvider = FutureProvider.family<void, Duration>((
  ref,
  wait,
) {
  final completer = Completer<void>();
  final timer = Timer(wait, () {
    if (!completer.isCompleted) completer.complete();
  });
  ref.onDispose(timer.cancel);
  return completer.future;
});

/// Resolved [ThemeMode] for [MaterialApp], derived from the user preference
/// (and weather sunrise/sunset when preference is [AppThemePreference.location]).
final themeModeProvider = Provider<ThemeMode>((ref) {
  final preference = ref.watch(themePreferenceProvider);
  switch (preference) {
    case AppThemePreference.device:
      return ThemeMode.system;
    case AppThemePreference.light:
      return ThemeMode.light;
    case AppThemePreference.dark:
      return ThemeMode.dark;
    case AppThemePreference.location:
      final weather = ref.watch(WeatherProviders.weatherNotifier);
      final timeUntilRefresh = weather.durationUntilNextDayNightChange();
      ref.watch(_dayNightBoundaryProvider(timeUntilRefresh));
      return weather.isNight() ? ThemeMode.dark : ThemeMode.light;
  }
});
