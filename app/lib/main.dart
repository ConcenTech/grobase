import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_logging/sentry_logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/components/solar/solar_energy_diagram_v2.dart';
import 'core/env/env.dart';
import 'routes/app_router.dart';
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

  SentryWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  await OfflineStorage.ensureInitialized();

  if (!kUseMocks) {
    await OnlineDatabaseService.initialize();
  }

  await SolarEnergyDiagramV2.precache();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await SentryFlutter.init(
    (options) {
      options.dsn = Env.sentryDsn;
      options.addIntegration(LoggingIntegration());
      options.enableLogs = true;
      options.debug = true;
      // Drop transient auth refresh failures (DNS/network not ready on resume).
      // These are retryable and handled via onAuthStateChange onError handlers.
      options.beforeSend = (event, hint) {
        final throwable = event.throwable ?? hint.throwable;
        if (throwable is AuthRetryableFetchException) {
          return null;
        }
        final message = throwable?.toString() ?? '';
        if (message.contains('AuthRetryableFetchException') ||
            (message.contains('Failed host lookup') &&
                message.contains('refresh_token'))) {
          return null;
        }
        return event;
      };
    },
    appRunner: () => runApp(
      SentryWidget(
        child: ProviderScope(
          overrides: kUseMocks ? MockSyncService.overrides : [],
          child: const MainApp(),
        ),
      ),
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: MaterialApp.router(
        key: AppRouter.routerKey,
        debugShowCheckedModeBanner: false,
        title: 'Grobase',
        themeMode: themeMode,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: router.router,
      ),
    );
  }
}
