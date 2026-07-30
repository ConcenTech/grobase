import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/theme_provider.dart';
import '../../theme/app_theme_preference.dart';

class ThemePreferenceWidget extends ConsumerWidget {
  const ThemePreferenceWidget({super.key});

  void _setTheme(AppThemePreference preference, WidgetRef ref) {
    ref.read(themePreferenceProvider.notifier).setPreference(preference);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themePreferenceProvider);

    return ListTile(
      title: const Text('Theme'),
      subtitle: Text(theme.description),
      trailing: DropdownButton<AppThemePreference>(
        value: theme,
        items: const [
          DropdownMenuItem(value: .location, child: Text('Location')),
          DropdownMenuItem(value: .device, child: Text('Device')),
          DropdownMenuItem(value: .light, child: Text('Light')),
          DropdownMenuItem(value: .dark, child: Text('Dark')),
        ],
        onChanged: (value) => _setTheme(value!, ref),
      ),
    );
  }
}
