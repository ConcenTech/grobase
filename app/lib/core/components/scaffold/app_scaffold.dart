import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../screens/systems/systems_screen.dart';
import '../../../services/database/database_providers.dart';
import '../logo.dart';
import '../solar/weather_background.dart';
import 'navigation_bar.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.showAppName = false,
    this.padding,
    this.actions = const [],
    this.showBackButton = false,
    this.bottomSheet,
    this.sideNavigationBar,
    this.bottomNavigationBar,
  });

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

  final Widget? sideNavigationBar;

  final Widget? bottomNavigationBar;

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
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(DatabaseProviders.syncState, (previous, next) {
      if (next.hasError) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SyncErrorSnackBar(
            message: next.error!,
            onRetry: () {
              messenger.hideCurrentSnackBar();
              ref.read(DatabaseProviders.syncService).restart();
            },
          ),
        );
      }
    });

    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const RepaintBoundary(child: SkyBackground()),
          Row(
            children: [
              ?sideNavigationBar,
              Expanded(
                child: SafeArea(
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
              ),
            ],
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

  static const kSideAppBarMinWidth = 75.0;
  static const List<NavigationBarItem> items = [
    NavigationBarItem(
      icon: Icon(Icons.home),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationBarItem(
      icon: Icon(Icons.solar_power),
      selectedIcon: Icon(Icons.solar_power),
      label: 'Systems',
    ),
    NavigationBarItem(
      icon: Icon(Icons.settings),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

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
    final isLandscape = MediaQuery.orientationOf(context) == .landscape;

    return AppScaffold(
      sideNavigationBar: isLandscape
          ? SideNavigationBar(
              index: shell.currentIndex,
              items: items,
              onDestinationSelected: shell.goBranch,
              midWidth: kSideAppBarMinWidth,
            )
          : null,
      bottomNavigationBar: !isLandscape
          ? BottomNavigationBar(
              index: shell.currentIndex,
              items: items,
              onDestinationSelected: shell.goBranch,
            )
          : null,
      body: shell,
      title: _title,
      actions: _actions,
      padding: _padding,
    );
  }
}

class SyncErrorSnackBar extends SnackBar {
  SyncErrorSnackBar({
    required String message,
    required VoidCallback onRetry,
    super.key,
  }) : super(
         content: Text(message),
         duration: const Duration(seconds: 8),
         action: SnackBarAction(label: 'Retry', onPressed: onRetry),
         behavior: SnackBarBehavior.floating,
       );
}
