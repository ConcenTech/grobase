import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Wraps a list of widgets in a padding that is appropriate for a bottom sheet.
class BottomSheetContainer extends StatelessWidget {
  const BottomSheetContainer({
    super.key,
    required this.children,
    this.spacing = 0.0,
  });
  final List<Widget> children;

  final double spacing;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 24,
        bottom: math.max(viewInsets.bottom, 16),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: spacing,
          children: children,
        ),
      ),
    );
  }
}
