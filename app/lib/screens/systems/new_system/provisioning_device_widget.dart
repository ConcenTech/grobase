import 'package:flutter/material.dart';

import '../../../core/components/animations/node_searching_animation.dart';
import '../../../core/components/bottom_sheet_container.dart';
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

    return BottomSheetContainer(
      spacing: 22.0,
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
    );
  }
}
