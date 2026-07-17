import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/async_status.dart';
import '../../core/utils/auth_errors.dart';
import '../../core/utils/validators.dart';
import 'auth_column.dart';

class AuthRegisterWidget extends ConsumerStatefulWidget {
  const AuthRegisterWidget({super.key, this.showEmailConfirmation = false});

  /// Bypass registration form and show email confirmation.
  ///
  /// Used when user has completed registration previously or on
  /// another device but has not yet confirmed their email.
  final bool showEmailConfirmation;

  @override
  ConsumerState<AuthRegisterWidget> createState() => _AuthRegisterWidgetState();
}

class _AuthRegisterWidgetState extends ConsumerState<AuthRegisterWidget> {
  final _formKey = GlobalKey<FormState>();

  String? _email;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _termsAgreed = false;

  @override
  void initState() {
    super.initState();

    if (widget.showEmailConfirmation) {
      ref.read(_registerAccountProvider.notifier).accountRegistered();
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    final form = _formKey.currentState!;

    if (form.validate()) {
      form.save();
      ref
          .read(_registerAccountProvider.notifier)
          .registerAccount(_email!, _passwordController.text) //
          .then((success) {
            if (success) {
              TextInput.finishAutofillContext();
            }
          });
    }
  }

  void _navigateToHome() {
    if (mounted) {
      GoRouter.of(context).go('/home');
    }
  }

  void _checkEmailConfirmed() {
    ref
        .read(_registerAccountProvider.notifier)
        .checkEmailConfirmed(_email!, _passwordController.text);
  }

  void _resendEmailConfirmation() {
    ref.read(_registerAccountProvider.notifier).resendEmailConfirmation();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_registerAccountProvider);

    return state.maybeWhen(
      success: (_) {
        if (state.emailConfirmed) {
          return AuthColumn(
            children: [
              Text(
                'Registration complete!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Your email has been confirmed. You can now get started',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _navigateToHome,
                child: const Text('Continue'),
              ),
            ],
          );
        } else {
          return AuthColumn(
            children: [
              Text(
                'You\'re one click away!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Please confirm your email to complete registration.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (state.error != null) ...[
                const SizedBox(height: 16),
                Text(
                  state.error!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _checkEmailConfirmed,
                child: const Text('Email Confirmed'),
              ),
              TextButton(
                onPressed: _resendEmailConfirmation,
                child: const Text('Resend Confirmation Email'),
              ),
            ],
          );
        }
      },
      orElse: () {
        final isLoading = state.status == .loading;

        return Form(
          key: _formKey,
          child: AutofillGroup(
            child: AuthColumn(
              children: [
                TextFormField(
                  key: const Key('email-field'),
                  restorationId: 'email-field',
                  enabled: !isLoading,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: Validators.email,
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => _email = value,
                ),
                TextFormField(
                  enabled: !isLoading,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: Validators.password,
                  autofillHints: const [AutofillHints.password],
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  controller: _passwordController,
                  onFieldSubmitted: isLoading ? null : (_) => _register(),
                ),
                TextFormField(
                  enabled: !isLoading,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      Validators.confirmPassword(v, _passwordController.text),
                  autofillHints: const [AutofillHints.password],
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  controller: _confirmPasswordController,
                  onFieldSubmitted: isLoading || !_termsAgreed
                      ? null
                      : (_) => _register(),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('I agree to the Terms and Conditions'),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _termsAgreed,

                  onChanged: (value) {
                    setState(() {
                      _termsAgreed = value ?? false;
                    });
                  },
                ),
                if (state.error != null)
                  Text(
                    state.error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),

                const SizedBox(height: 16),
                FilledButton(
                  onPressed: isLoading || !_termsAgreed ? null : _register,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Register'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RegisterAccountState with AsyncStatusMixin<void> {
  @override
  final String? error;

  @override
  final AsyncStatus status;

  final String? email;

  final bool emailConfirmed;

  _RegisterAccountState({
    this.status = AsyncStatus.initial,
    this.error,
    this.email,
    this.emailConfirmed = false,
  });

  _RegisterAccountState copyWith({
    AsyncStatus? status,
    String? error,
    String? email,
    bool? emailConfirmed,
  }) {
    return _RegisterAccountState(
      status: status ?? this.status,
      error: error ?? this.error,
      email: email ?? this.email,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
    );
  }

  @override
  void get data {}
}

class _RegisterAccountNotifier extends Notifier<_RegisterAccountState> {
  @override
  _RegisterAccountState build() => _RegisterAccountState();

  /// Registers a new account with the provided email and password.
  ///
  /// An email confirmation will be sent to the user, and the notifier will
  /// listen for authentication state changes to detect when the email is
  /// confirmed.
  Future<bool> registerAccount(String email, String password) async {
    state = state.copyWith(status: AsyncStatus.loading);
    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'com.concentech.grobase://login-callback',
      );
      state = state.copyWith(status: AsyncStatus.success, email: email);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(
        status: AsyncStatus.error,
        error: AuthErrors.userFacingMessage(e),
      );
    } catch (e) {
      state = state.copyWith(
        status: AsyncStatus.error,
        error: AuthErrors.unexpected,
      );
    }
    return false;
  }

  /// Account has been registered previously or on another device.
  ///
  /// To get here, the user must have signed in to the app so email
  /// should be available in the session.
  void accountRegistered() {
    final email = Supabase.instance.client.auth.currentSession?.user.email;
    if (email == null) {
      state = state.copyWith(
        status: AsyncStatus.error,
        error: 'No email associated with current session',
      );
      return;
    }
    state = _RegisterAccountState(status: AsyncStatus.success, email: email);
  }

  /// Checks if the user's email has been confirmed by attempting to log the
  /// user in with the provided email and password.
  ///
  /// This is useful for users who may have confirmed their email in a
  /// different tab or device and want to refresh their confirmation status.
  void checkEmailConfirmed(String email, String password) {
    try {
      Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(status: AsyncStatus.success, emailConfirmed: true);
    } on AuthException catch (e) {
      if (AuthErrors.isEmailNotConfirmed(e)) {
        state = state.copyWith(
          status: AsyncStatus.success,
          emailConfirmed: false,
        );
      } else {
        state = state.copyWith(
          status: AsyncStatus.error,
          error: AuthErrors.userFacingMessage(e),
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AsyncStatus.error,
        error: AuthErrors.unexpected,
      );
    }
  }

  /// Resends the email confirmation to the user's email address.
  void resendEmailConfirmation() async {
    final oldState = state;
    state = state.copyWith(status: AsyncStatus.loading);

    if (state.email == null) {
      state = state.copyWith(
        status: AsyncStatus.error,
        error: 'No email to resend confirmation to',
      );
      return;
    }

    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: state.email!,
      );

      state = oldState;
    } on AuthException catch (e) {
      state = state.copyWith(
        status: AsyncStatus.error,
        error: AuthErrors.userFacingMessage(e),
      );
    } catch (e) {
      state = state.copyWith(
        status: AsyncStatus.error,
        error: AuthErrors.unexpected,
      );
    }
  }
}

final _registerAccountProvider =
    NotifierProvider.autoDispose<
      _RegisterAccountNotifier,
      _RegisterAccountState
    >(_RegisterAccountNotifier.new);
