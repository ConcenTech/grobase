import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/components/animations/connection_node_widget.dart';

class ProvisioningErrorWidget extends StatelessWidget {
  const ProvisioningErrorWidget({
    super.key,
    required this.error,
    this.details,
    required this.onRetry,
  });

  const ProvisioningErrorWidget.permissions({super.key, required this.onRetry})
    : error =
          'Bluetooth and location permissions are required '
          'to search for gateways.',
      details =
          'Please enable these permissions in your device settings '
          'and try again.';

  final String error;
  final String? details;

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 24,
        bottom: max(MediaQuery.of(context).viewInsets.bottom, 16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16.0,
        children: [
          const ConnectionNodeWidget(icon: Icons.warning, color: Colors.orange),
          Text(
            error,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          if (details != null)
            Text(
              details!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
