import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,

          colors: [
            if (isDarkMode) ...[
              const Color(0xFF1B2440),
            ] else
              const Color(0xFFBBDDF5),
            theme.scaffoldBackgroundColor,
          ],
        ),
      ),
      child: child,
    );
  }
}
