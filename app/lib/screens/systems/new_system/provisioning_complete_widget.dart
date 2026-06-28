import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/components/animations/node_searching_animation.dart';

class ProvisioningCompleteWidget extends StatelessWidget {
  const ProvisioningCompleteWidget({super.key, required this.onComplete});

  final VoidCallback onComplete;

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
        children: [
          Text(
            'Your system has been successfully connected',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const NodeConnectivityWidget(
            icon: Icons.solar_power,
            type: .receiving,
            isActive: false,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: onComplete,
              child: const Text('Finish'),
            ),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}
