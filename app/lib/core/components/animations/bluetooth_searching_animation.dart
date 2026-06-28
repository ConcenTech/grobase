import 'package:flutter/material.dart';

import 'connection_node_widget.dart';

class BluetoothSearchingAnimation extends StatefulWidget {
  const BluetoothSearchingAnimation({super.key});

  @override
  State<BluetoothSearchingAnimation> createState() =>
      _BluetoothSearchingAnimationState();
}

/// A Widget that contains a circle bluetooth icon, with semi-transparant
/// circles that radiate outwards from the center, to indicate that the app is
/// searching for devices.
///
/// The circles should animate outwards, and fade out as they move away from the center. The animation should repeat indefinitely.
class _BluetoothSearchingAnimationState
    extends State<BluetoothSearchingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accent = colorScheme.primary;

    return SizedBox(
      width: 160,
      height: 160,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final baseProgress = _controller.value;

          return Stack(
            alignment: Alignment.center,
            children: [
              for (final index in [0, 1, 2])
                _PulseRing(
                  progress: (baseProgress + index / 3) % 1,
                  color: accent,
                ),
              const ConnectionNodeWidget(
                icon: Icons.bluetooth,
                heroTag: 'bluetooth_node',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PulseRing extends StatelessWidget {
  const _PulseRing({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final eased = Curves.easeOut.transform(progress);
    final scale = 0.25 + (eased * 1.35);
    final opacity = (1 - progress).clamp(0.0, 1.0) * 0.35;

    return IgnorePointer(
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.8), width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
