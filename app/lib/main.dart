import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/components/solar/solar_energy_diagram_v2.dart';
import 'routes/app_router.dart';
import 'routes/mock_app_router.dart';
import 'services/database/database_providers.dart';
import 'services/database/mocks/mock_online_database_service.dart';
import 'services/database/mocks/mock_sync_service.dart';
import 'services/database/offline_storage.dart';
import 'services/database/online_database_service.dart';
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

  runApp(
    ProviderScope(
      overrides: kUseMocks
          ? [
              DatabaseProviders.onlineDatabase.overrideWithValue(
                MockOnlineDatabaseService(),
              ),
              DatabaseProviders.syncService.overrideWith((ref) {
                final service = MockSyncService(
                  online: ref.watch(DatabaseProviders.onlineDatabase),
                  offline: ref.watch(DatabaseProviders.offlineDatabase),
                  onSyncChange: (complete) {
                    DatabaseProviders.setSyncComplete(ref, complete);
                  },
                );
                return service..init();
              }),
              appRouterProvider.overrideWithValue(MockAppRouter()),
            ]
          : [],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    ref.listen(DatabaseProviders.syncService, (_, _) {});

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Grobase',
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router.router,
    );
  }
}
