import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'connection_node_widget.dart';

enum ConnectivtyType {
  /// Node is styled to indicate it is sending data
  sending,

  /// Node is styled to indicate it is receiving data
  receiving,

  /// Node has pulsing rings around it to indicate searching for a connection
  searching,
}

class NodeConnectivityWidget extends StatefulWidget {
  const NodeConnectivityWidget({
    super.key,
    required this.icon,
    this.color,
    this.isActive = true,
    this.type = ConnectivtyType.searching,
  });

  final IconData icon;

  final Color? color;

  final bool isActive;

  final ConnectivtyType type;

  @override
  State<NodeConnectivityWidget> createState() => _NodeConnectivityWidgetState();
}

class _NodeConnectivityWidgetState extends State<NodeConnectivityWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    if (widget.type != .searching) {
      _buildParticles();
    }

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant NodeConnectivityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
    }
    if (widget.type == .searching && widget.type != oldWidget.type) {
      _particles = [];
    } else if (widget.type != .searching && oldWidget.type == .searching) {
      _buildParticles();
    }
  }

  void _buildParticles() {
    final random = math.Random();
    _particles = List.generate(45, (i) {
      return _Particle(
        angle: random.nextDouble() * 2 * math.pi, // Completely random direction
        speedFactor:
            0.7 + random.nextDouble() * 0.6, // Some move fast, some drift slow
        size: 1.5 + random.nextDouble() * 2.5, // Varied particle sizes
        phase: random.nextDouble(), // Staggered lifecycles
      );
    });
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
    final nodeColor = widget.color ?? accent;

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
              if (widget.type == ConnectivtyType.searching)
                for (final index in [0, 1, 2])
                  _PulseRing(
                    progress: (baseProgress + index / 3) % 1,
                    color: nodeColor,
                    isActive: widget.isActive,
                  ),
              _RadialPackets(
                progress: _controller.value,
                color: nodeColor,
                type: widget.type,
                particles: _particles,
                isActive: widget.isActive,
              ),
              ConnectionNodeWidget(icon: widget.icon, color: nodeColor),
            ],
          );
        },
      ),
    );
  }
}

class _PulseRing extends StatelessWidget {
  const _PulseRing({
    required this.progress,
    required this.color,
    required this.isActive,
  });

  final double progress;
  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final eased = Curves.easeOut.transform(progress);
    final scale = 0.25 + (eased * 1.35);
    final opacity = (1 - progress).clamp(0.0, 1.0) * 0.35;

    return IgnorePointer(
      child: Transform.scale(
        scale: scale,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: isActive ? opacity : 0,
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

// The new random particle blueprint
class _Particle {
  _Particle({
    required this.angle,
    required this.speedFactor,
    required this.size,
    required this.phase,
  });

  final double angle;
  final double speedFactor;
  final double size;
  final double phase;
}

class _RadialPackets extends StatelessWidget {
  const _RadialPackets({
    required this.progress,
    required this.color,
    required this.type,
    required this.particles,
    required this.isActive,
  });

  final double progress;
  final Color color;
  final ConnectivtyType type;
  final List<_Particle> particles;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (type == ConnectivtyType.searching) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isActive ? 1.0 : 0.0,
        child: CustomPaint(
          size: const Size(160, 160),
          painter: _ParticleFieldPainter(
            progress: progress,
            color: color,
            type: type,
            particles: particles,
          ),
        ),
      ),
    );
  }
}

class _ParticleFieldPainter extends CustomPainter {
  _ParticleFieldPainter({
    required this.progress,
    required this.color,
    required this.type,
    required this.particles,
  });

  final double progress;
  final Color color;
  final ConnectivtyType type;
  final List<_Particle> particles;

  static const double coreRadius = 24.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.width / 2;
    final isSending = type == ConnectivtyType.sending;

    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      // Stagger each individual particle's lifecycle progression
      final double t = (progress + p.phase) % 1.0;

      // Scale distance interpolation based on the particle's custom speed factor
      // This forces particles to die out or reach bounds at different times
      final double relativeProgress = (t * p.speedFactor).clamp(0.0, 1.0);

      double radius;
      double alpha;

      if (isSending) {
        // RADIATE OUTWARD: Core -> Edge
        final eased = Curves.decelerate.transform(relativeProgress);
        radius = coreRadius + eased * (maxRadius - coreRadius);

        // Fades away into nothingness as it disperses outward
        alpha = (1.0 - relativeProgress);
      } else {
        // RADIATE INWARD: Edge -> Core
        final eased = Curves.easeInCubic.transform(relativeProgress);
        radius = maxRadius - eased * (maxRadius - coreRadius);

        // Starts faint at outer boundary, builds intensity, then vanishes into the core
        alpha = relativeProgress * math.sin(t * math.pi);
      }

      // Ensure smooth fade transitions near the absolute boundaries
      final edgeFade = math.sin(t * math.pi);
      final finalAlpha = (alpha * edgeFade).clamp(0.0, 1.0);

      if (finalAlpha <= 0.05) continue;

      // Add a tiny bit of angular drift based on time to make the flight path organic
      final double drift = math.sin(t * 6.28 + p.phase * 10) * 0.08;
      final double currentAngle = p.angle + drift;

      final double dx = center.dx + radius * math.cos(currentAngle);
      final double dy = center.dy + radius * math.sin(currentAngle);

      paint.color = color.withValues(alpha: finalAlpha);

      // Render the individual glowing particle speck
      canvas.drawCircle(
        Offset(dx, dy),
        p.size * (0.4 + finalAlpha * 0.6),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleFieldPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.type != type ||
        oldDelegate.color != color;
  }
}
