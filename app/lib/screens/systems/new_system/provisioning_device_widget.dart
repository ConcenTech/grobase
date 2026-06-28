import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/components/animations/node_searching_animation.dart';
import '../../../services/provisioning_service.dart';

class ProvisioningDeviceWidget extends StatelessWidget {
  const ProvisioningDeviceWidget._({super.key, required this.state})
    : assert(
        state is ProvisioningDeviceRegisteringGateway ||
            state is ProvisioningDeviceWritingConfig,
        'ProvisioningDeviceWidget can only be used with ProvisioningDeviceRegisteringGateway '
        'or ProvisioningDeviceWritingConfig states.',
      );

  const ProvisioningDeviceWidget.registeringGateway({
    super.key,
    required ProvisioningDeviceRegisteringGateway this.state,
  });

  const ProvisioningDeviceWidget.writingConfig({
    super.key,
    required ProvisioningDeviceWritingConfig this.state,
  });

  final ProvisioningDevice state;

  bool get _isRegistering => state is ProvisioningDeviceRegisteringGateway;

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
            _isRegistering
                ? 'Registering gateway...'
                : 'Writing configuration...',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          NodeConnectivityWidget(
            icon: Icons.solar_power,
            type: _isRegistering ? .sending : .receiving,
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}
