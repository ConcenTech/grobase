import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/components/animations/node_searching_animation.dart';

class ConnectingToWifiWidget extends StatelessWidget {
  const ConnectingToWifiWidget({super.key}) : _isError = false;
  const ConnectingToWifiWidget.error({super.key}) : _isError = true;

  final bool _isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final primaryColor = theme.colorScheme.primary;
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
      ),
    );
  }
}
