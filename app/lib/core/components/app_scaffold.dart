import 'package:flutter/material.dart';

import 'gradient_background.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.padding,
    this.actions = const [],
    this.showBackButton = false,
    this.bottomSheet,
  });

  final Widget body;
  final String? title;

  /// The content padding
  ///
  /// Defaults to EdgeInsets.all(8.0) if not provided.
  final EdgeInsetsGeometry? padding;

  final List<Widget> actions;

  final bool showBackButton;

  final Widget? bottomSheet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      if (showBackButton)
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      Expanded(
                        child: Text(
                          title!,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
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
      bottomSheet: bottomSheet,
    );
  }
}
