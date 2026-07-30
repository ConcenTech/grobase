import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/location.dart';
import '../../../services/provisioning_service.dart';
import 'connecting_to_device_widget.dart';
import 'connecting_to_wifi_widget.dart';
import 'new_system_form.dart';
import 'new_system_information_widget.dart';
import 'provisioning_complete_widget.dart';
import 'provisioning_device_widget.dart';
import 'provisioning_error_widget.dart';
import 'searching_for_devices_widget.dart';
import 'wifi_credentials_form.dart';

/// A set of widgets that allow the user to create a new system.
///
/// It is a complete flow that collects the system name and location, and then
/// provisions a gateway with the user.
class NewSystemWizard extends ConsumerWidget {
  const NewSystemWizard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provisioningState = ref.watch(provisioningServiceProvider);

    final child = switch (provisioningState) {
      ProvisioningInformation() => NewSystemInformationWidget(
        onStart: () {
          ref.read(provisioningServiceProvider.notifier).readyForProvisioning();
        },
      ),
      ProvisioningInitial() => NewSystemForm(
        onSave: (String displayName, Location location) {
          ref
              .read(provisioningServiceProvider.notifier)
              .startProvisioningScan(displayName, location);
        },
      ),
      ProvisioningScanning(:final devices) => SearchingForDevicesWidget(
        devices: devices,
        onDeviceSelected: (device) {
          ref
              .read(provisioningServiceProvider.notifier)
              .connectToDevice(device);
        },
      ),
      ProvisioningError(:final error) => ProvisioningErrorWidget(
        error: 'An error occurred while provisioning the gateway.',
        details: error,
        onRetry: () {
          ref.read(provisioningServiceProvider.notifier).reset();
        },
      ),
      ProvisioningPermissionsError() => ProvisioningErrorWidget.permissions(
        onRetry: () {
          ref.read(provisioningServiceProvider.notifier).reset();
        },
      ),
      ProvisioningDeviceConnecting(:final device) => ConnectingToDeviceWidget(
        device: device,
        status: .connecting,
      ),
      ProvisioningDeviceConnected(:final device) => ConnectingToDeviceWidget(
        device: device,
        status: .connected,
      ),
      ProvisioningDeviceDisconnected(:final device) => ConnectingToDeviceWidget(
        device: device,
        status: .disconnected,
        onRetry: () {
          ref.read(provisioningServiceProvider.notifier).reset();
        },
      ),
      ProvisioningDeviceError(:final device, :final error, :final retryState) =>
        ConnectingToDeviceWidget(
          device: device,
          status: .error,
          error: error,
          onRetry: () {
            ref.read(provisioningServiceProvider.notifier).retry(retryState);
          },
        ),
      ProvisioningDeviceIdentityRead(:final device) => WifiCredentialsForm(
        onSave: (String ssid, String password) {
          ref
              .read(provisioningServiceProvider.notifier)
              .sendWifiCredentials(device, ssid: ssid, password: password);
        },
      ),
      ProvisioningDeviceWiFiConnecting() => const ConnectingToWifiWidget(),
      ProvisioningDeviceRegisteringGateway() =>
        ProvisioningDeviceWidget.registeringGateway(state: provisioningState),
      ProvisioningDeviceWritingConfig() =>
        ProvisioningDeviceWidget.writingConfig(state: provisioningState),
      ProvisioningComplete() => ProvisioningCompleteWidget(
        onComplete: () {
          // Close the bottom sheet
          Navigator.of(context).pop();
        },
      ),
      ProvisioningState() => const SizedBox.shrink(),
    };

    return AnimatedSize(duration: kThemeAnimationDuration, child: child);
  }
}
