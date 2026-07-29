import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../core/components/app_scaffold.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/invite/invite_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/systems/systems_screen.dart';
import 'app_router.dart';

class MockAppRouter extends AppRouter {
  MockAppRouter() {
    router = GoRouter(
      navigatorKey: AppRouter.navigatorKey,
      routes: _testRoutes,
    );
  }

  String? _authRequiredRedirect(BuildContext context, GoRouterState state) {
    return null;
  }

  List<RouteBase> get _testRoutes => [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const InviteScreen(token: 'abcdefghijklmnopqrstuvwxyz0123456789'),
      redirect: (_, _) {
        SystemChrome.setPreferredOrientations([.portraitUp]);
        return null;
      },
      onExit: (context, state) {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        return true;
      },
    ),
  ];

  List<RouteBase> get _routes => [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
      redirect: (context, state) {
        return '/home';
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const AuthScreen(),
      redirect: (context, state) {
        return '/home';
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

  @override
  void dispose() {
    //
  }
}
