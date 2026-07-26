import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/components/app_scaffold.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/systems/systems_screen.dart';

final appRouterProvider = Provider<AppRouter>((ref) {
  final router = AppRouter();
  router.init();
  ref.onDispose(router.dispose);
  return router;
});

class AppRouter {
  late final GoRouter router;

  GoTrueClient get _auth => Supabase.instance.client.auth;

  static final navigatorKey = GlobalKey<NavigatorState>();
  static final routerKey = GlobalKey();

  late final StreamSubscription<AuthState> _authSubscription;

  void init() {
    router = GoRouter(navigatorKey: navigatorKey, routes: _routes);
    _listenToAuthChanges();
  }

  String? _authRequiredRedirect(BuildContext context, GoRouterState state) {
    final session = _auth.currentSession;
    if (session == null) {
      return '/login';
    }
    return null;
  }

  // List<RouteBase> get _testRoutes => [
  //   GoRoute(path: '/', builder: (context, state) => const TestPage()),
  // ];

  List<RouteBase> get _routes => [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
      redirect: (context, state) {
        final session = _auth.currentSession;
        if (session == null) {
          return '/login';
        } else {
          return '/home';
        }
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const AuthScreen(),
      redirect: (context, state) {
        final session = _auth.currentSession;
        if (session != null) {
          return '/home';
        }
        return null;
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) => HomeScaffold(child),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              redirect: _authRequiredRedirect,
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/systems',
              builder: (context, state) => const SystemsScreen(),
              redirect: _authRequiredRedirect,
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
              redirect: _authRequiredRedirect,
            ),
          ],
        ),
      ],
    ),
  ];

  void _listenToAuthChanges() {
    _authSubscription = _auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        navigatorKey.currentContext?.go('/home');
      } else if (data.event == AuthChangeEvent.signedOut) {
        navigatorKey.currentContext?.go('/login');
      }
    });
  }

  void dispose() {
    _authSubscription.cancel();
    router.dispose();
  }
}
