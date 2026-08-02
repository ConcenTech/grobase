import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/components/scaffold/app_scaffold.dart';
import '../models/database/inverter.drift.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/invite/invite_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/system_details/system_details_screen.dart';
import '../screens/systems/systems_screen.dart';

/// Custom-scheme invite links opened from the GitHub Pages fallback.
///
/// Format: `com.concentech.grobase://open/invite?token=<token>`
const kInviteDeepLinkScheme = 'com.concentech.grobase';
const kInviteDeepLinkHost = 'open';

final appRouterProvider = Provider<AppRouter>((ref) {
  final router = AppRouter();
  router.init();
  ref.onDispose(router.dispose);
  return router;
});

final _logger = Logger('AppRouter');

class AppRouter {
  late final GoRouter router;
  late final AppLinks _appLinks;

  GoTrueClient get _auth => Supabase.instance.client.auth;

  static final navigatorKey = GlobalKey<NavigatorState>();
  static final routerKey = GlobalKey();

  late final StreamSubscription<AuthState> _authSubscription;
  late final StreamSubscription<Uri> _appLinkSubscription;

  void init() {
    router = GoRouter(navigatorKey: navigatorKey, routes: _routes);
    _listenToAuthChanges();
  }

  void listenToAppLinks() {
    _appLinks = AppLinks();
    _appLinkSubscription = _appLinks.uriLinkStream
        .where((uri) => uri.host == kInviteDeepLinkHost)
        .listen(
          (uri) {
            final token = inviteTokenFromUri(uri);
            if (token == null) {
              return;
            }
            _logger.info('Opening invite from deep link');
            toInvite(navigatorKey.currentContext!, token);
          },
          onError: (Object e, StackTrace st) {
            _logger.warning('Invite deep link stream error', e, st);
          },
        );
  }

  String? _authRequiredRedirect(BuildContext context, GoRouterState state) {
    final session = _auth.currentSession;
    if (session == null) {
      return Uri(
        path: '/login',
        queryParameters: {'redirect': state.uri.toString()},
      ).toString();
    }
    return null;
  }

  String? _inviteAuthRequiredRedirect(
    BuildContext context,
    GoRouterState state,
  ) {
    final token = state.uri.queryParameters['token']?.trim() ?? '';
    if (token.isEmpty) {
      return _auth.currentSession == null ? '/login' : '/home';
    }
    if (_auth.currentSession == null) {
      return Uri(
        path: '/login',
        queryParameters: {'redirect': state.uri.toString()},
      ).toString();
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
      builder: (context, state) {
        final hasRedirect =
            safeAuthRedirect(state.uri.queryParameters['redirect']) != null;
        return AuthScreen(initialState: hasRedirect ? .login : null);
      },
      redirect: (context, state) {
        final session = _auth.currentSession;
        if (session != null) {
          final redirect = safeAuthRedirect(
            state.uri.queryParameters['redirect'],
          );
          return redirect ?? '/home';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/invite',
      builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? '';
        return InviteScreen(token: token);
      },
      redirect: _inviteAuthRequiredRedirect,
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
            GoRoute(
              path: '/system-details',
              builder: (context, state) =>
                  SystemDetailsScreen(inverter: state.extra as Inverter),
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
    // onError is required: GoTrue emits AuthRetryableFetchException on the
    // auth stream when token refresh fails (common on resume before DNS/network
    // is ready). Without onError, Dart treats that as an unhandled exception
    // and cancels this subscription.
    _authSubscription = _auth.onAuthStateChange.listen(
      (data) {
        // Use the GoRouter instance directly — navigatorKey.currentContext is the
        // Navigator, which sits above RouteBase.builder, so GoRouterState.of fails.
        final location = router.state.uri;
        if (data.event == .signedIn && location.path == '/login') {
          final redirect = safeAuthRedirect(
            location.queryParameters['redirect'],
          );
          router.go(redirect ?? '/home');
        }

        if (data.event == .signedOut) {
          router.go('/login');
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        _logger.warning('Auth state stream error', error, stackTrace);
      },
    );
  }

  void dispose() {
    _authSubscription.cancel();
    _appLinkSubscription.cancel();
    router.dispose();
  }

  static String? safeAuthRedirect(String? redirect) {
    if (redirect == null || redirect.isEmpty) return null;
    if (!redirect.startsWith('/') || redirect.startsWith('//')) return null;
    return redirect;
  }

  static void toHomeOrRedirect(BuildContext context) {
    final redirect = safeAuthRedirect(
      GoRouterState.of(context).uri.queryParameters['redirect'],
    );
    if (redirect == null) {
      context.go('/home');
    } else {
      context.go(redirect);
    }
  }

  void toInvite(BuildContext context, String token) {
    context.go(_inviteLocation(token));
  }

  /// Builds the in-app location for an invite token.
  String _inviteLocation(String token) =>
      Uri(path: '/invite', queryParameters: {'token': token}).toString();

  /// Extracts an invite token from a custom-scheme or https invite URI.
  String? inviteTokenFromUri(Uri uri) {
    final token = uri.queryParameters['token']?.trim();
    if (token == null || token.isEmpty) return null;

    final isCustomInvite =
        uri.scheme == kInviteDeepLinkScheme &&
        uri.host == kInviteDeepLinkHost &&
        uri.path.startsWith('/invite');

    final isHttpsInvite =
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.path.contains('/invite');

    if (isCustomInvite || isHttpsInvite) return token;
    return null;
  }
}
