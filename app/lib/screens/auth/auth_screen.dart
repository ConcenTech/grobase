import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/logo.dart';
import '../../core/components/segmented_switcher.dart';
import '../../core/components/solar/solar_energy_diagram.dart';
import '../../core/components/solar/solar_energy_diagram_v2.dart';
import 'auth_column.dart';
import 'auth_login_widget.dart';
import 'auth_password_reset_widget.dart';
import 'auth_register_widget.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_authStateProvider);

    void onSegmentedSwitcherChanged(int index) {
      switch (index) {
        case 0:
          ref.read(_authStateProvider.notifier).showLogin();
          break;
        case 1:
          ref.read(_authStateProvider.notifier).showRegister();
          break;
      }
    }

    void showLogin() => ref.read(_authStateProvider.notifier).showLogin();

    void showForgotPassword() =>
        ref.read(_authStateProvider.notifier).showForgotPassword();

    void showEmailConfirmationRequired() =>
        ref.read(_authStateProvider.notifier).showConfirmEmail();

    int switcherIndex() {
      switch (state) {
        case _AuthState.ready:
          return 0;
        case _AuthState.login:
          return 0;
        case _AuthState.register:
          return 1;
        case _AuthState.confirmEmail:
          return 1;
        case _AuthState.forgotPassword:
          return 0;
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: const _AuthScreenBody(),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedSize(
          duration: kThemeAnimationDuration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state == _AuthState.ready)
                _AuthWidget(onLoginSelected: showLogin)
              else if (state == _AuthState.confirmEmail)
                const AuthRegisterWidget(showEmailConfirmation: true)
              else ...[
                SegmentedSwitcher(
                  labels: const ['Login', 'Register'],
                  selectedIndex: switcherIndex(),
                  onChanged: onSegmentedSwitcherChanged,
                ),
                switch (state) {
                  .login => AuthLoginWidget(
                    onForgotPassword: showForgotPassword,
                    onEmailConfirmationRequired: showEmailConfirmationRequired,
                  ),
                  .register => const AuthRegisterWidget(),
                  .forgotPassword => AuthPasswordResetWidget(onBack: showLogin),
                  _AuthState.ready ||
                  _AuthState.confirmEmail => const SizedBox.shrink(),
                },
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthScreenBody extends StatelessWidget {
  const _AuthScreenBody();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const SkyBackground(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final diagram = SolarEnergyDiagramV2(
                // showWeatherEffects: true,
                data: SolarEnergyData(
                  batteryLevel: 75,
                  batteryWatts: isDark ? -500 : 1000,
                  gridWatts: isDark ? 200 : -100,
                  houseWatts: isDark ? 300 : 400,
                  solarWatts: isDark ? 0 : 1500,
                ),
              );

              final windowHeight = constraints.maxHeight;
              // Clamp the diagram to a maximum of 350 pixels, using bottom padding to
              // keep it pinned to top on larger devices.
              // So bottom padding will be window height - 350, but not less than 0.
              final bottomPadding = max(windowHeight - 550.0, 0.0);

              return Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: diagram,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AuthWidget extends StatelessWidget {
  const _AuthWidget({required this.onLoginSelected});

  final VoidCallback onLoginSelected;

  @override
  Widget build(BuildContext context) {
    return AuthColumn(
      children: [
        const Center(child: LogoWidget()),
        Text(
          'Effortless Energy Management.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          'The ultimate Growatt companion app for monitoring and optimizing '
          'your solar energy system.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: onLoginSelected,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Get Started'),
        ),
      ],
    );
  }
}

enum _AuthState { ready, login, register, confirmEmail, forgotPassword }

class _AuthStateNotifier extends Notifier<_AuthState> {
  @override
  _AuthState build() => _AuthState.ready;

  void showLogin() => state = _AuthState.login;
  void showRegister() => state = _AuthState.register;
  void showConfirmEmail() => state = _AuthState.confirmEmail;
  void showForgotPassword() => state = _AuthState.forgotPassword;
}

final _authStateProvider = NotifierProvider<_AuthStateNotifier, _AuthState>(
  _AuthStateNotifier.new,
);
