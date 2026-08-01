import 'dart:math';

import 'package:flutter/material.dart';

/// Style used for chart axis tick labels (measure and render must match).
TextStyle chartAxisLabelStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodySmall ??
      Theme.of(context).textTheme.bodyMedium!;
}

Size _measureChartAxisLabel(BuildContext context, String text) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: chartAxisLabelStyle(context)),
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

/// Width of an X-axis label at the current text scale.
double chartXLabelWidth(BuildContext context) {
  return _measureChartAxisLabel(context, '24').width;
}

/// Default [SideTitleWidget.space] between a left-axis label and the plot.
const chartYLabelSideTitleSpace = 8.0;

/// Width to reserve for Y-axis side titles using the widest scaled label text.
double chartYLabelReservedSize(BuildContext context, Iterable<String> labels) {
  var maxWidth = 0.0;
  for (final label in labels) {
    maxWidth = max(maxWidth, _measureChartAxisLabel(context, label).width);
  }

  // SideTitleWidget puts [chartYLabelSideTitleSpace] inside reservedSize;
  // add a small buffer for glyph rounding.
  return max(40, maxWidth.ceilToDouble() + chartYLabelSideTitleSpace + 8);
}

/// Size for [AxisTitles.axisNameSize] and bottom tick [SideTitles.reservedSize],
/// scaled with system text size.
///
/// Left axis names are rotated, so this value is the horizontal space they
/// occupy (= text height). Bottom axis names and hour ticks use the same
/// height vertically.
double chartAxisNameSize(BuildContext context) {
  // Any single-line sample works; height is driven by style + text scale.
  return max(16, _measureChartAxisLabel(context, 'Hg').height.ceilToDouble());
}

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

/// Returns an X-axis interval that is a multiple of [baseStep] so labels fit
/// in [plotWidth] given [labelWidth] (already text-scaled).
double fittingXInterval({
  required double plotWidth,
  required double labelWidth,
}) {
  const hourSteps = [1.0, 2.0, 3.0, 4.0, 6.0, 8.0, 12.0];
  final edgeInset = labelWidth / 8; // half glyph + fitInside distanceFromEdge
  final maxSteps = max(1, (plotWidth / (labelWidth * 1.5 + edgeInset)).floor());
  final ideal = 24.0 / maxSteps;

  return hourSteps.firstWhere(
    (step) => step >= ideal,
    orElse: () => hourSteps.first,
  );
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
