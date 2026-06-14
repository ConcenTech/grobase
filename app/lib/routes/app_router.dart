import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/auth/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';

final appRouterProvider = Provider<AppRouter>((ref) {
  final router = AppRouter();
  router.init();
  ref.onDispose(router.dispose);
  return router;
});

class AppRouter {
  late final GoRouter router;

  final GoTrueClient auth = Supabase.instance.client.auth;

  static final navigatorKey = GlobalKey<NavigatorState>();

  late final StreamSubscription<AuthState> _authSubscription;

  void init() {
    router = GoRouter(navigatorKey: navigatorKey, routes: _routes);
    _listenToAuthChanges();
  }

  List<RouteBase> get _routes => [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
      redirect: (context, state) {
        final session = auth.currentSession;
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
        final session = auth.currentSession;
        if (session != null) {
          return '/home';
        }
        return null;
      },
    ),
    // GoRoute(
    //   path: 'login-callback',
    //   builder: (context, state) {
    //     return const AuthScreen();
    //   },
    // ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
      redirect: (context, state) {
        final session = auth.currentSession;
        if (session == null) {
          return '/login';
        }
        return null;
      },
    ),
  ];

  void _listenToAuthChanges() {
    _authSubscription = auth.onAuthStateChange.listen((data) {
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
