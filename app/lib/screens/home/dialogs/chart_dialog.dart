import 'dart:math';

import 'package:flutter/material.dart';

TextStyle _chartAxisLabelStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodySmall ??
      Theme.of(context).textTheme.bodyMedium!;
}

Size _measureChartAxisLabel(BuildContext context, String text) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: _chartAxisLabelStyle(context)),
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
    maxLines: 1,
  )..layout();
  return painter.size;
}

/// Height of a Y-axis side title using the actual scaled label text.
double chartYLabelHeight(BuildContext context, String sampleLabel) {
  return _measureChartAxisLabel(context, sampleLabel).height;
}

/// Width to reserve for Y-axis side titles using the widest scaled label text.
double chartYLabelReservedSize(BuildContext context, Iterable<String> labels) {
  var maxWidth = 0.0;
  for (final label in labels) {
    maxWidth = max(maxWidth, _measureChartAxisLabel(context, label).width);
  }

  // Leave room for SideTitleWidget spacing and keep a small minimum.
  return max(35, maxWidth + 12);
}

/// Space reserved for bottom time labels when estimating the plot area.
const chartBottomTitlesReserved = 28.0;

/// Returns a Y-axis interval that is a multiple of [baseStep] so labels fit
/// in [plotHeight] given [labelHeight] (already text-scaled).
double fittingYInterval({
  required double minY,
  required double maxY,
  required double baseStep,
  required double plotHeight,
  required double labelHeight,
}) {
  assert(baseStep > 0);
  final range = maxY - minY;
  if (range <= 0 || plotHeight <= 0 || labelHeight <= 0) return baseStep;

  // Small gap so glyphs don't touch at high text scales.
  final minSpacing = labelHeight * 1.25;
  final maxLabelCount = max(2, (plotHeight / minSpacing).floor());
  final maxSteps = maxLabelCount - 1;
  final stepsAtBase = max(1, (range / baseStep).round());
  if (stepsAtBase <= maxSteps) return baseStep;

  return baseStep * (stepsAtBase / maxSteps).ceil();
}

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
