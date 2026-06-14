import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/async_status.dart';
import '../../core/utils/validators.dart';
import 'auth_column.dart';

class AuthPasswordResetWidget extends ConsumerStatefulWidget {
  const AuthPasswordResetWidget({required this.onBack, super.key});

  /// Called when the user wants to go back to the login screen.
  final VoidCallback? onBack;

  @override
  ConsumerState<AuthPasswordResetWidget> createState() =>
      _AuthPasswordResetWidgetState();
}

class _AuthPasswordResetWidgetState
    extends ConsumerState<AuthPasswordResetWidget> {
  final _formKey = GlobalKey<FormState>();

  String? _email;

  void _save() {
    final form = _formKey.currentState!;

    if (form.validate()) {
      form.save();

      final notifier = ref.read(_resetPasswordProvider.notifier);
      notifier.resetPassword(_email!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_resetPasswordProvider);

    return state.maybeWhen(
      success: (_) {
        return AuthColumn(
          children: [
            Text(
              'Password reset email sent!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'Please check your inbox for instructions.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onBack,
              child: const Text('Back to Login'),
            ),
          ],
        );
      },
      orElse: () {
        final isLoading = state.status == .loading;
        final hasError = state.status == .error;

        return Form(
          key: _formKey,
          child: AuthColumn(
            children: [
              Text(
                'Forgot you password?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Enter your email address to receive a password reset link.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (hasError)
                Text(
                  state.error ?? 'An error occurred',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.email,
                autofillHints: const [AutofillHints.email],
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSaved: (value) => _email = value,
                onFieldSubmitted: isLoading ? null : (_) => _save(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : _save,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Confirm'),
              ),
              TextButton(
                onPressed: widget.onBack,
                child: const Text('Back to Login'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResetPasswordState with AsyncStatusMixin<void> {
  @override
  final String? error;

  @override
  final AsyncStatus status;

  _ResetPasswordState({this.status = AsyncStatus.initial, this.error});

  _ResetPasswordState copyWith({
    String? email,
    AsyncStatus? status,
    String? error,
  }) {
    return _ResetPasswordState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  void get data {}
}

class _ResetPasswordNotifier extends Notifier<_ResetPasswordState> {
  @override
  _ResetPasswordState build() => _ResetPasswordState();

  Future<void> resetPassword(String email) async {
    state = state.copyWith(status: AsyncStatus.loading);
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'com.concentech.grobase://login-callback',
      );
      state = state.copyWith(status: AsyncStatus.success);
    } on AuthException catch (e) {
      state = state.copyWith(status: AsyncStatus.error, error: e.message);
    } catch (e) {
      state = state.copyWith(
        status: AsyncStatus.error,
        error: 'An unexpected error occurred',
      );
    }
  }
}

final _resetPasswordProvider =
    NotifierProvider.autoDispose<_ResetPasswordNotifier, _ResetPasswordState>(
      _ResetPasswordNotifier.new,
    );
