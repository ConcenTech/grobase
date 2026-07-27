import 'package:flutter/material.dart';

import '../../../core/components/animations/node_searching_animation.dart';
import '../../../core/components/bottom_sheet_container.dart';

class ConnectingToWifiWidget extends StatelessWidget {
  const ConnectingToWifiWidget({super.key}) : _isError = false;
  const ConnectingToWifiWidget.error({super.key}) : _isError = true;

  final bool _isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final primaryColor = theme.colorScheme.primary;
    return BottomSheetContainer(
      children: [
        Text(
          _isError
              ? 'Failed to connect to WiFi. \n'
                    'Please check your credentials and try again.'
              : 'Connecting to WiFi... \n'
                    'This may take a few moments.',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        NodeConnectivityWidget(
          icon: Icons.wifi,
          color: _isError ? errorColor : primaryColor,
          isActive: !_isError,
          type: .searching,
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}
