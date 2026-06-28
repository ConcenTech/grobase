import 'package:flutter/material.dart';

import 'connection_node_widget.dart';

enum ConnectionSatus { connecting, connected, disconnected, error }

class BluetoothConnectingAnimation extends StatefulWidget {
  const BluetoothConnectingAnimation({super.key, required this.status});

  final ConnectionSatus status;

  @override
  State<BluetoothConnectingAnimation> createState() =>
      _BluetoothConnectingAnimationState();
}

class _BluetoothConnectingAnimationState
    extends State<BluetoothConnectingAnimation> {
  _ProgressVisuals _resolveVisuals(
    ColorScheme colorScheme,
    ConnectionSatus status,
  ) {
    return switch (status) {
      .connecting => _ProgressVisuals(
        value: null,
        indicatorColor: colorScheme.primary,
        backgroundColor: null,
      ),
      .connected => _ProgressVisuals(
        value: null,
        indicatorColor: colorScheme.inversePrimary,
        backgroundColor: colorScheme.primary,
      ),
      .error || .disconnected => _ProgressVisuals(
        value: 0.0,
        indicatorColor: colorScheme.error,
        backgroundColor: colorScheme.errorContainer,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final errorColor = colorScheme.error;
    final progress = _resolveVisuals(colorScheme, widget.status);

    return Row(
      children: [
        const ConnectionNodeWidget(
          icon: Icons.bluetooth,
          heroTag: 'bluetooth_node',
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: progress.value,
            color: progress.indicatorColor,
            backgroundColor: progress.backgroundColor,
          ),
        ),
        ConnectionNodeWidget(
          icon: Icons.solar_power,
          color: widget.status == .error || widget.status == .disconnected
              ? errorColor
              : null,
        ),
      ],
    );
  }
}

class _ProgressVisuals {
  const _ProgressVisuals({
    required this.value,
    required this.indicatorColor,
    required this.backgroundColor,
  });

  final double? value;
  final Color indicatorColor;
  final Color? backgroundColor;
}
