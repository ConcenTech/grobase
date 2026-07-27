import 'package:flutter/material.dart';

import '../../../core/components/animations/node_searching_animation.dart';
import '../../../core/components/bottom_sheet_container.dart';

class ProvisioningCompleteWidget extends StatelessWidget {
  const ProvisioningCompleteWidget({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomSheetContainer(
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
    );
  }
}
