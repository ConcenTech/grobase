import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/systems/systems_screen.dart';
import 'logo.dart';
import 'solar/weather_background.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.showAppName = false,
    this.padding,
    this.actions = const [],
    this.showBackButton = false,
    this.bottomSheet,
    this.navigationBar,
  });

  final Widget? navigationBar;

  final Widget body;

  /// The title shown in the app bar.
  ///
  /// When [title] is provided, [showAppName] is ignored.
  final String? title;

  /// Shows the grobase logo in the app bar. Cannot be used in combination with
  /// [title].
  ///
  /// When [title] is provided, [showAppName] is ignored.
  ///
  /// Defaults to `false`.
  final bool showAppName;

  /// The content padding
  ///
  /// Defaults to EdgeInsets.all(8.0) if not provided.
  final EdgeInsetsGeometry? padding;

  /// A row of widgets shown on the right side of the app bar.
  ///
  /// Typically used to show action buttons.
  final List<Widget> actions;

  final bool showBackButton;

  final Widget? bottomSheet;

  bool get _shouldBuildAppBar =>
      title != null || showAppName || actions.isNotEmpty || showBackButton;

  Widget _buildTitle(BuildContext context) {
    if (title != null) {
      return Text(title!, style: Theme.of(context).textTheme.headlineLarge);
    }

    if (showAppName) {
      return const LogoWidget();
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: navigationBar,
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const RepaintBoundary(child: SkyBackground()),
          SafeArea(
            left: false,
            right: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_shouldBuildAppBar)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        if (showBackButton)
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        Expanded(child: _buildTitle(context)),
                        if (actions.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8.0,
                            children: actions,
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: padding ?? const EdgeInsets.all(8.0),
                    child: body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: bottomSheet,
    );
  }
}

class HomeScaffold extends StatelessWidget {
  const HomeScaffold(this.shell, {super.key});

  final StatefulNavigationShell shell;

  String? get _title => switch (shell.currentIndex) {
    0 => null,
    1 => 'Systems',
    2 => 'Settings',
    _ => null,
  };

  List<Widget> get _actions => switch (shell.currentIndex) {
    0 => [],
    1 => const [NewSystemButton()],
    2 => const [],
    _ => const [],
  };

  EdgeInsetsGeometry? get _padding => switch (shell.currentIndex) {
    0 => const EdgeInsets.all(0),
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: shell,
      title: _title,
      actions: _actions,
      padding: _padding,
      navigationBar: NavigationBar(
        onDestinationSelected: (index) => shell.goBranch(index),
        selectedIndex: shell.currentIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.solar_power),
            label: 'Systems',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
