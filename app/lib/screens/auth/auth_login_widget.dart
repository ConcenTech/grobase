import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/async_status.dart';
import '../../core/utils/validators.dart';
import 'auth_column.dart';

class AuthLoginWidget extends ConsumerStatefulWidget {
  const AuthLoginWidget({
    super.key,
    required this.onForgotPassword,
    required this.onEmailConfirmationRequired,
  });

  final VoidCallback onForgotPassword;
  final VoidCallback onEmailConfirmationRequired;

  @override
  ConsumerState<AuthLoginWidget> createState() => _AuthLoginWidgetState();
}

class _AuthLoginWidgetState extends ConsumerState<AuthLoginWidget> {
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  void _login() {
    final form = _formKey.currentState!;

    if (form.validate()) {
      form.save();
      ref.read(_loginProvider.notifier).login(_email!, _password!);
    }
  }

  void _navigateToHome() {
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_loginProvider);

    ref.listen(_loginProvider, (_, next) {
      if (next.status == AsyncStatus.success) {
        if (next.emailConfirmed) {
          _navigateToHome();
        } else {
          widget.onEmailConfirmationRequired();
        }
      }
    });

    return state.maybeWhen(
      orElse: () {
        final isLoading = state.status == .loading;

        return Form(
          key: _formKey,
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
                onSaved: (value) => _password = value,
                onFieldSubmitted: isLoading ? null : (_) => _login(),
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
                onPressed: isLoading ? null : _login,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
              TextButton(
                onPressed: isLoading ? null : widget.onForgotPassword,
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LoginState with AsyncStatusMixin<void> {
  @override
  final String? error;

  @override
  final AsyncStatus status;

  final bool emailConfirmed;

  _LoginState({
    this.status = AsyncStatus.initial,
    this.error,
    this.emailConfirmed = false,
  });

  _LoginState copyWith({
    AsyncStatus? status,
    String? error,
    String? email,
    bool? emailConfirmed,
  }) {
    return _LoginState(
      status: status ?? this.status,
      error: error ?? this.error,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
    );
  }

  @override
  void get data {}
}

class _LoginNotifier extends Notifier<_LoginState> {
  @override
  _LoginState build() => _LoginState();

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: .loading);

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null) {
        state = state.copyWith(
          status: .success,
          emailConfirmed: response.session!.user.emailConfirmedAt != null,
        );
      } else {
        state = state.copyWith(
          status: .error,
          error: 'Login failed. Please check your credentials.',
        );
      }
    } on AuthException catch (e) {
      state = state.copyWith(status: .error, error: e.message);
    } catch (e) {
      state = state.copyWith(
        status: .error,
        error: 'An unexpected error occurred',
      );
    }
  }
}

final _loginProvider =
    NotifierProvider.autoDispose<_LoginNotifier, _LoginState>(
      _LoginNotifier.new,
    );
