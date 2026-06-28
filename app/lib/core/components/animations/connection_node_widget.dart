import 'package:flutter/material.dart';

class ConnectionNodeWidget extends StatelessWidget {
  const ConnectionNodeWidget({
    super.key,
    required this.icon,
    this.color,
    this.heroTag,
  });

  final IconData icon;

  final Color? color;

  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accent = colorScheme.primary;

    Widget child = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (color ?? accent).withValues(alpha: 0.12),
      ),
      child: Icon(icon, size: 36, color: color ?? accent),
    );

    if (heroTag != null) {
      child = Hero(tag: heroTag!, child: child);
    }

    return child;
  }
}
