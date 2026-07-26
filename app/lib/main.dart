import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/components/solar/solar_energy_diagram_v2.dart';
import 'routes/app_router.dart';
import 'services/app_logger.dart';
import 'services/database/database_providers.dart';
import 'services/database/mocks/mock_sync_service.dart';
import 'services/database/offline_storage.dart';
import 'services/database/online_database_service.dart';
import 'services/theme_provider.dart';
import 'theme/theme.dart';

// Title font: Montserrat, weight: 600
// Gro color: #6EB92B
// base color: dark mode: white light mode: #37474F

// Light scaffold background: const Color(0xFFBBDDF5)
// Dark scaffold background: const Color(0xFF1B2440)

/// When true, use mock data for local development and never touch Supabase.
const kUseMocks = true && kDebugMode;

void main() async {
  LicenseRegistry.addLicense(() async* {
    final String license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(<String>['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();

  await OfflineStorage.ensureInitialized();

  if (!kUseMocks) {
    await OnlineDatabaseService.initialize();
  }

  await SolarEnergyDiagramV2.precache();

  AppLogger.instance.flush();

  runApp(
    ProviderScope(
      overrides: kUseMocks ? MockSyncService.overrides : [],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    ref.listen(DatabaseProviders.syncService, (_, _) {});

    return MaterialApp.router(
      key: AppRouter.routerKey,
      debugShowCheckedModeBanner: false,
      title: 'Grobase',
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router.router,
    );
  }
}
