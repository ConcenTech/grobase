import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'animations/wind_turbines_animation.dart';

export 'animations/wind_turbines_animation.dart' show WindTurbinesStatus;

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.centered = true, this.size = 40});

  final bool centered;
  final double size;

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(),
    );

    if (centered) {
      child = Center(child: child);
    }

    return child;
  }
}

class WindTurbinesIndicator extends StatelessWidget {
  const WindTurbinesIndicator({
    super.key,
    required this.status,
    this.caption,
    this.details,
    this.textStyle,
  });

  final WindTurbinesStatus status;
  final String? caption;
  final String? details;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isError = status == WindTurbinesStatus.error;

    final captionStyle = GoogleFonts.montserrat(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: isError
          ? theme.colorScheme.error
          : (isDark ? Colors.white : const Color(0xFF37474F)),
    ).merge(textStyle);

    final defaultText = isError ? 'Something went wrong' : 'Loading...';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        children: [
          WindTurbinesAnimation(status: status),
          Text(
            caption ?? defaultText,
            style: captionStyle,
            textAlign: TextAlign.center,
          ),
          if (details != null) Text(details!, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
