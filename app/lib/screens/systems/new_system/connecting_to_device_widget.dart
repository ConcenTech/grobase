import 'package:flutter/material.dart';

import '../../../core/components/animations/bluetooth_connecting_animation.dart';
import '../../../core/components/bottom_sheet_container.dart';

class ConnectingToDeviceWidget extends StatelessWidget {
  const ConnectingToDeviceWidget({
    super.key,
    required this.device,
    required this.status,
    this.onRetry,
    this.error,
  }) : assert(
         (status == .error || status == .disconnected) && onRetry != null ||
             (status != .error && status != .disconnected) && onRetry == null,
         'onRetry must be provided when status is error or disconnected, and should be null otherwise.',
       );

  final String device;

  final ConnectionSatus status;

  final String? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      children: [
        Text(switch (status) {
          .connecting => 'Connecting to $device. \n',
          .connected =>
            'Connected to $device \n'
                'Configuring gateway.',
          .error =>
            'Failed to connect to $device. \n'
                '${error ?? 'An unknown error occurred.'}',
          .disconnected => '$device disconnected. \n',
        }, textAlign: TextAlign.center),
        BluetoothConnectingAnimation(status: status),
        const SizedBox(height: 16),
        if (status == .error || status == .disconnected)
          ElevatedButton(onPressed: onRetry, child: const Text('Retry'))
        else
          const SizedBox(height: 36),
      ],
    );
  }
}
