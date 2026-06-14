import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/async_status.dart';

class AuthStateNotifier extends Notifier<AuthState> {
  final GoTrueClient auth = Supabase.instance.client.auth;

  @override
  AuthState build() => const AuthState.ready();

  StreamSubscription? _authChangesStream;

  /// Registers a new account with the provided email and password.
  ///
  /// An email confirmation will be sent to the user, and the notifier will
  /// listen for authentication state changes to detect when the email is
  /// confirmed.
  Future<void> registerAccount(String email, String password) async {
    state = state.copyWith(asyncStatus: AsyncStatus.loading, error: null);

    try {
      await auth.signUp(email: email, password: password);
      // After signing up, we wait for the user to confirm their email
      state = state.copyWith(
        uiStatus: AuthUIStatus.confirmEmail,
        asyncStatus: AsyncStatus.initial,
        email: email,
      );
      unawaited(_waitForEmailConfirmation());
    } on AuthException catch (e) {
      state = state.copyWith(asyncStatus: AsyncStatus.error, error: e.message);
    } catch (e) {
      state = state.copyWith(
        asyncStatus: AsyncStatus.error,
        error: 'An unexpected error occurred',
      );
    }
  }

  /// Listens for authentication state changes to detect when the user's
  /// email is confirmed.
  Future<void> _waitForEmailConfirmation() async {
    _authChangesStream = auth.onAuthStateChange.listen((data) {
      // If the user is not on the confirm email screen, we can stop listening
      if (state.uiStatus != AuthUIStatus.confirmEmail) {
        _authChangesStream?.cancel();
        return;
      }
      // Check if the email is confirmed and update the state accordingly
      if (data.session?.user.emailConfirmedAt != null) {
        state = state.copyWith(
          asyncStatus: AsyncStatus.success,
          emailConfirmed: true,
        );
        _authChangesStream?.cancel();
      }
    });
    ref.onDispose(() {
      _authChangesStream?.cancel();
    });
  }

  /// Checks if the user's email has been confirmed by inspecting the current
  /// session.
  ///
  /// This is useful for users who may have confirmed their email in a
  /// different tab or device and want to refresh their confirmation status.
  void checkEmailConfirmed() {
    final user = Supabase.instance.client.auth.currentSession?.user;

    if (user?.emailConfirmedAt != null) {
      state = state.copyWith(emailConfirmed: true);
    } else {
      state = state.copyWith(
        emailConfirmed: false,
        error: 'Email not confirmed yet',
      );
    }
  }

  void resendEmailConfirmation() async {
    if (state.email == null) {
      state = state.copyWith(
        asyncStatus: AsyncStatus.error,
        error: 'No email to resend confirmation to',
      );
      return;
    }

    try {
      await auth.resend(type: OtpType.signup, email: state.email!);
    } on AuthException catch (e) {
      state = state.copyWith(asyncStatus: AsyncStatus.error, error: e.message);
    } catch (e) {
      state = state.copyWith(
        asyncStatus: AsyncStatus.error,
        error: 'An unexpected error occurred',
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(asyncStatus: AsyncStatus.loading, error: null);

    try {
      final response = await auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null) {
        final emailConfirmed = response.session!.user.emailConfirmedAt != null;
        state = state.copyWith(
          asyncStatus: emailConfirmed
              ? AsyncStatus.success
              : AsyncStatus.initial,
          uiStatus: emailConfirmed ? null : AuthUIStatus.confirmEmail,
          emailConfirmed: emailConfirmed,
        );
      } else {
        state = state.copyWith(
          asyncStatus: AsyncStatus.error,
          error: 'Login failed. Please check your credentials.',
        );
      }
    } on AuthException catch (e) {
      state = state.copyWith(asyncStatus: AsyncStatus.error, error: e.message);
    } catch (e) {
      state = state.copyWith(
        asyncStatus: AsyncStatus.error,
        error: 'An unexpected error occurred',
      );
    }
  }

  void showLogin() => state = const AuthState.login();
  void showRegister() => state = const AuthState.register();
  void showConfirmEmail(String email) =>
      state = AuthState.confirmEmail(email: email);
  void showForgotPassword() => state = const AuthState.forgotPassword();
}

class AuthState {
  final AuthUIStatus uiStatus;
  final AsyncStatus asyncStatus;
  final String? error;
  final String? email;
  final bool emailConfirmed;

  const AuthState({
    required this.uiStatus,
    this.asyncStatus = AsyncStatus.initial,
    this.error,
    this.email,
    this.emailConfirmed = false,
  });

  const AuthState.ready() : this(uiStatus: AuthUIStatus.ready);

  const AuthState.login() : this(uiStatus: AuthUIStatus.login);

  const AuthState.register() : this(uiStatus: AuthUIStatus.register);

  const AuthState.confirmEmail({required String email})
    : this(uiStatus: AuthUIStatus.confirmEmail, email: email);

  const AuthState.forgotPassword()
    : this(uiStatus: AuthUIStatus.forgotPassword);

  AuthState copyWith({
    AuthUIStatus? uiStatus,
    AsyncStatus? asyncStatus,
    String? error,
    String? email,
    bool? emailConfirmed,
  }) {
    return AuthState(
      uiStatus: uiStatus ?? this.uiStatus,
      asyncStatus: asyncStatus ?? this.asyncStatus,
      error: error ?? this.error,
      email: email ?? this.email,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
    );
  }
}

enum AuthUIStatus {
  /// Initial state, shows a welcome message and a button to go to the login screen
  ready,

  /// Shows the login form
  login,

  /// Shows the registration form
  register,

  /// Asks the user to confirm their email
  confirmEmail,

  /// Allows the user to reset their password
  forgotPassword,
}
