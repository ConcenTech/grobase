import 'dart:math';

import 'package:flutter/material.dart';

class ChartDialog extends StatelessWidget {
  const ChartDialog({super.key, this.title, required this.chart});

  final Widget? title;
  final Widget chart;

  double _approximateFontHeight(TextStyle style) {
    if (style.height == null || style.fontSize == null) {
      return 60;
    }
    return style.fontSize! * style.height!;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    const inset = EdgeInsets.symmetric(horizontal: 16, vertical: 24);
    final titleHeight = title == null
        ? 0
        : _approximateFontHeight(Theme.of(context).textTheme.titleLarge!);
    final width = size.width - inset.horizontal;
    final height = min(width + titleHeight + 50, size.height - inset.vertical);

    return Dialog(
      insetPadding: inset,
      child: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.titleLarge!,
                    child: title!,
                  ),
                ),
              Expanded(child: chart),
            ],
          ),
        ),
      ),
    );
  }
}
