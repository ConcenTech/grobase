import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/async_status.dart';
import '../../core/utils/auth_errors.dart';
import '../../core/utils/validators.dart';

/// This widget is used for both password reset and password change flows, since
/// the UI is the same.
///
/// When used for password reset, supabase will handle the flow automatically
/// providing the user triggered the reset email from within the app.
class AuthChangePasswordWidget extends ConsumerStatefulWidget {
  const AuthChangePasswordWidget({super.key});

  @override
  ConsumerState<AuthChangePasswordWidget> createState() =>
      _AuthChangePasswordWidgetState();
}

class _AuthChangePasswordWidgetState
    extends ConsumerState<AuthChangePasswordWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  void _toHome() {
    if (mounted) {
      context.go('/home');
    }
  }

  void _save() {
    final form = _formKey.currentState!;

    if (form.validate()) {
      form.save();

      ref
          .read(_changePasswordProvider.notifier)
          .changePassword(_passwordController1.text) //
          .then((success) {
            if (success) {
              TextInput.finishAutofillContext();
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_changePasswordProvider);

    return state.maybeWhen(
      success: (data) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Password changed!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _toHome, child: const Text('Continue')),
          ],
        );
      },
      orElse: () {
        final isLoading = state.status == .loading;
        final hasError = state.status == .error;

        return Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Set your new password',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Your new password should be different from \n'
                  'passwords you have used before. \n\n'
                  'It must be at least 8 characters long and contain \n'
                  'a mix of letters, numbers, and symbols.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController1,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  autofillHints: const [AutofillHints.newPassword],
                  autofocus: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: Validators.password,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _passwordController2,
                  decoration: const InputDecoration(
                    labelText: 'Confirm your password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    _passwordController1.text,
                  ),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: isLoading ? null : (_) => _save(),
                ),
                if (hasError)
                  Text(
                    state.error ?? 'An error occurred',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isLoading ? null : _save,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Change Password'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  dispose() {
    _passwordController1.dispose();
    _passwordController2.dispose();
    super.dispose();
  }
}

class _ChangePasswordState with AsyncStatusMixin<void> {
  @override
  final String? error;

  @override
  final AsyncStatus status;

  _ChangePasswordState({this.status = AsyncStatus.initial, this.error});

  _ChangePasswordState copyWith({AsyncStatus? status, String? error}) {
    return _ChangePasswordState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  void get data {}
}

class _ChangePasswordNotifier extends Notifier<_ChangePasswordState> {
  @override
  _ChangePasswordState build() => _ChangePasswordState();

  Future<bool> changePassword(String password) async {
    state = state.copyWith(status: AsyncStatus.loading);
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: password),
      );
      state = state.copyWith(status: AsyncStatus.success);
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
}

final _changePasswordProvider =
    NotifierProvider.autoDispose<_ChangePasswordNotifier, _ChangePasswordState>(
      _ChangePasswordNotifier.new,
    );
