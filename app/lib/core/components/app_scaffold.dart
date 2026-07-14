import 'package:flutter/material.dart';

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
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const RepaintBoundary(child: SkyBackground()),
          SafeArea(
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
