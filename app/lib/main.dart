import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/components/solar/solar_energy_diagram_v2.dart';
import 'routes/app_router.dart';
import 'services/database/database_providers.dart';
import 'services/database/offline_storage.dart';
import 'theme/theme.dart';

const supabaseDebugUrl = 'http://localhost:54321';
const supabaseDebugAnonKey = 'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH';

// Title font: Montserrat, weight: 600
// Gro color: #6EB92B
// base color: dark mode: white light mode: #37474F

// Light scaffold background: const Color(0xFFBBDDF5)
// Dark scaffold background: const Color(0xFF1B2440)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await OfflineStorage.ensureInitialized();

  /// These should be set via `--dart-define` at build time, but we provide
  /// defaults for local development..
  const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: supabaseDebugUrl,
  );
  const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: supabaseDebugAnonKey,
  );

  if (!kDebugMode) {
    if (supabaseUrl.isEmpty || supabaseUrl == supabaseDebugUrl) {
      throw Exception('SUPABASE_URL is not set');
    }
    if (supabasePublishableKey.isEmpty ||
        supabasePublishableKey == supabaseDebugAnonKey) {
      throw Exception('SUPABASE_PUBLISHABLE_KEY is not set');
    }
  }

  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );

  await SolarEnergyDiagramV2.precache();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    ref.listen(DatabaseProviders.syncService, (_, _) {});

    return MaterialApp.router(
      title: 'Grobase',
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router.router,
    );
  }
}
