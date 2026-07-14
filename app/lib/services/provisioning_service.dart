import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' as ble;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/device_config.dart';
import '../models/gateway_registration.dart';
import '../models/location.dart';
import 'bluetooth/bluetooth_service.dart';
import 'bluetooth/wifi_status.dart';
import 'database/online_database_service.dart';

final _logger = Logger('ProvisioningService');

final provisioningServiceProvider =
    NotifierProvider<ProvisioningService, ProvisioningState>(
      ProvisioningService.new,
    );

/// Provisioning should be a state machine that handles the following states:
/// - Initial: No provisioning scan is running.
/// - Scanning: A scan for provisioning devices is running.
/// - DeviceConnecting: A connection to a provisioning device is being
/// established.
/// - DeviceConnected: A connection to a provisioning device is established.
/// - DeviceDisconnected: A connection to a provisioning device was establishe
///  but is now disconnected.
/// - DeviceError: An error occurred during provisioning.
/// - DeviceIdentityRead: A connection to a provisioning device is established
/// and the device identity has been read.
/// - DeviceWiFiConnecting: A connection to a provisioning device is established
/// and the device is attempting to connect to the WiFi network.
/// - DeviceRegisteringGateway: A connection to a provisioning device is
/// established, the device is connected to the WiFi network, and the gateway
/// is being registered with the server.
/// - DeviceWritingConfig: A connection to a provisioning device is established,
/// the device is connected to the WiFi network, the gateway is registered with
/// the server, and the device configuration is being written to the device.
/// - Complete: The provisioning process is complete and the device is ready to
/// use.
class ProvisioningService extends Notifier<ProvisioningState> {
  ProvisioningService();

  late final OnlineDatabaseService _db;
  late final BluetoothService _ble;

  late String _displayName;
  late Location _location;

  String? _ssid;
  String? _password;

  @override
  ProvisioningState build() {
    _db = ref.read(databaseProvider);
    _ble = ref.read(bluetoothProvider);

    ref.onDispose(disconnectFromDevice);

    return const ProvisioningInformation();
  }

  StreamSubscription<String>? _provisioningScanSubscription;
  StreamSubscription<ble.ConnectionStateUpdate>? _connectionSubscription;
  StreamSubscription<WifiStatus>? _wifiStatusSubscription;

  void reset() {
    _logger.info('Resetting provisioning service...');
    stopProvisioningScan();
    disconnectFromDevice();
    state = const ProvisioningInitial();
  }

  void retry(ProvisioningState retryState) {
    _logger.info('Retrying provisioning with state: ${retryState.runtimeType}');
    state = retryState;
  }

  Future<bool> _checkPermissions() async {
    bool locationPermission = await _checkPermission(Permission.location);
    bool bluetoothScan = await _checkPermission(Permission.bluetoothScan);
    bool bluetoothConnect = await _checkPermission(Permission.bluetoothConnect);
    return locationPermission && bluetoothScan && bluetoothConnect;
  }

  Future<bool> _checkPermission(Permission permission) async {
    bool isGranted = await permission.isGranted;
    if (!isGranted) {
      final result = await permission.request();
      isGranted = result.isGranted;
    }
    return isGranted;
  }

  void readyForProvisioning() {
    if (state is ProvisioningInformation) {
      state = const ProvisioningInitial();
    }
  }

  void startProvisioningScan(String displayName, Location location) async {
    _logger.info('Starting provisioning scan...');
    // Scan is already running
    if (_provisioningScanSubscription != null) {
      _logger.warning('Provisioning scan already running.');
      return;
    }

    _displayName = displayName;
    _location = location;

    state = const ProvisioningScanning({});

    if (!await _checkPermissions()) {
      _logger.severe('Location permission denied.');
      state = const ProvisioningPermissionsError(
        'Location permission denied. \n'
        'Please enable location permission and try again.',
      );
      return;
    }

    _provisioningScanSubscription = _ble
        .provisioningStream()
        .handleError((e, s) {
          _logger.severe(
            'Error occurred while scanning for provisioning devices.',
            e,
          );
          String error = 'An unexpected error occurred.';
          if (e is ble.GenericFailure ||
              e is ble.GenericFailure<ble.ScanFailure>) {
            _logger.severe('BLE error: ${e.message}');
            error = e.message;
          }
          state = ProvisioningError(error);
        })
        .listen((device) {
          // Stop scanning if we are no longer in the scanning state.
          // Likely in an error state.
          if (state is! ProvisioningScanning) {
            _logger.warning(
              'Provisioning scan stopped because state is no longer scanning.',
            );
            stopProvisioningScan();
            return;
          }

          final currentState = state as ProvisioningScanning;

          if (currentState.devices.contains(device)) {
            return;
          }

          _logger.info('Discovered provisioning device: $device');

          state = ProvisioningScanning({...currentState.devices, device});
        });
  }

  void stopProvisioningScan() {
    _provisioningScanSubscription?.cancel();
    _provisioningScanSubscription = null;
    _logger.info('Provisioning scan stopped.');
  }

  void connectToDevice(String device) {
    // stopProvisioningScan();

    _logger.info('Connecting to provisioning device: $device');

    state = ProvisioningDeviceConnecting(device);

    _connectionSubscription = _ble
        .connectionStream(device) //
        .listen(
          (update) {
            _logger.info(
              'Connection state update for $device: '
              '${update.connectionState}',
            );
            switch (update.connectionState) {
              case .connecting:
                state = ProvisioningDeviceConnecting(device);
                break;
              case .connected:
                state = ProvisioningDeviceConnected(device);
                _readIdentity(device);
                break;
              case .disconnected:
                // TODO: Verify disconnecting after writing config stops the error state
                // if (state is ProvisioningDeviceWritingConfig) {
                //   // Likely the config was written and the disconnection
                //   // happened before we stopped the stream.
                //   // TODO: Investigate whether the device is supposed to send an updated status after the config is written, before disconnecting.
                //   return;
                // }
                if (state is! ProvisioningDeviceConnecting) {
                  _logger.info(
                    'Disconnected from provisioning device: $device',
                  );
                  state = ProvisioningDeviceDisconnected(device);
                } else {
                  final error = update.failure?.message ?? 'Unknown error';
                  state = ProvisioningDeviceError(
                    device,
                    error: error,
                    retryState: const ProvisioningScanning({}),
                  );
                }

                disconnectFromDevice();
                break;
              case .disconnecting:
                break;
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            _logger.severe(
              'Connection error for provisioning device '
              '$device',
              error,
              stackTrace,
            );
            state = ProvisioningDeviceError(
              device,
              error: error.toString(),
              retryState: const ProvisioningScanning({}),
            );
            disconnectFromDevice();
          },
        );
  }

  void disconnectFromDevice() {
    _connectionSubscription?.cancel();
    _connectionSubscription = null;
    _wifiStatusSubscription?.cancel();
    _wifiStatusSubscription = null;
    _logger.info('Disconnected from provisioning device.');
  }

  void _readIdentity(String device) async {
    try {
      final gatewayStatus = await _ble.readStatus(device);

      if (gatewayStatus.status != .advertising) {
        _logger.severe(
          'Provisioning device is not in advertising state: '
          '$device - Status: ${gatewayStatus.status}',
        );
        state = ProvisioningDeviceError(
          device,
          error:
              'Provisioning device is not in advertising state. ${gatewayStatus.status.humanised}',
          retryState: const ProvisioningScanning({}),
        );
        return;
      }

      final hardwareId = await _ble.readHardwareId(device);
      final inverterSn = await _ble.readInverterSerialNumber(device);

      if (inverterSn.isEmpty || inverterSn == 'UNKNOWN') {
        _logger.severe(
          'Provisioning device returned an invalid inverter serial number: '
          '$device - Inverter SN: $inverterSn',
        );
        state = ProvisioningDeviceError(
          device,
          error:
              'Provisioning device returned an invalid inverter serial number. $inverterSn',
          retryState: const ProvisioningScanning({}),
        );
        return;
      }

      _logger.info(
        'Read identity from provisioning device: $device - '
        'Hardware ID: $hardwareId, '
        'Inverter SN: $inverterSn',
      );
      state = ProvisioningDeviceIdentityRead(
        device,
        hardwareId: hardwareId,
        inverterSn: inverterSn,
      );
    } catch (e) {
      _logger.severe(
        'Failed to read identity from provisioning device: $device',
        e,
      );
      state = ProvisioningDeviceError(
        device,
        error: e.toString(),
        retryState: const ProvisioningScanning({}),
      );
    }
  }

  void sendWifiCredentials(
    String device, {
    required String ssid,
    required String password,
  }) async {
    final currentState = state;
    if (currentState is! ProvisioningDeviceIdentityRead) {
      _logger.warning(
        'Cannot send WiFi credentials, '
        'state is mismatched: ${state.runtimeType}',
      );
      return;
    }

    _ssid = ssid;
    _password = password;

    state = ProvisioningDeviceWiFiConnecting(
      device,
      hardwareId: currentState.hardwareId,
      inverterSn: currentState.inverterSn,
    );

    _waitForWifiConnection(device);

    try {
      await _ble.writeWifiConfig(
        deviceId: device,
        ssid: ssid,
        password: password,
      );
      _logger.info('Sent WiFi credentials to provisioning device: $device');

      try {
        final deviceStatus = await _ble.readStatus(device);
        _logger.info(
          'Device status after WiFi write: ${deviceStatus.detail} '
          '(${deviceStatus.status})',
        );
      } catch (e) {
        _logger.warning('Failed to read device status after WiFi write: $e');
      }

      // #endregion
    } catch (e) {
      _logger.severe(
        'Failed to send WiFi credentials to provisioning device: $device',
        e,
      );
      state = ProvisioningDeviceError(
        device,
        error: 'Failed to send WiFi credentials to device',
        retryState: ProvisioningDeviceIdentityRead(
          currentState.device,
          hardwareId: currentState.hardwareId,
          inverterSn: currentState.inverterSn,
          ssid: _ssid,
          password: _password,
        ),
      );
    }
  }

  void _waitForWifiConnection(String device) {
    final currentState = state;
    if (currentState is! ProvisioningDeviceWiFiConnecting) {
      _logger.warning(
        'Cannot wait for WiFi connection, '
        'state is mismatched: ${state.runtimeType}',
      );
      return;
    }

    _logger.info('Waiting for provisioning device to connect to WiFi: $device');

    _wifiStatusSubscription = _ble
        .watchWifiStatus(device)
        .listen(
          (status) {
            _logger.info(
              'Provisioning device WiFi status update: '
              '$device - Status: $status',
            );

            _handleWifiStatusUpdate(device, currentState, status);
          },
          onError: (Object error, StackTrace stackTrace) {
            _logger.severe(
              'WiFi status subscription error for $device',
              error,
              stackTrace,
            );

            state = ProvisioningDeviceError(
              device,
              error: 'Failed to connect to WiFi',
              retryState: ProvisioningDeviceIdentityRead(
                currentState.device,
                hardwareId: currentState.hardwareId,
                inverterSn: currentState.inverterSn,
                ssid: _ssid,
                password: _password,
              ),
            );
          },
        );
  }

  void _handleWifiStatusUpdate(
    String device,
    ProvisioningDeviceWiFiConnecting waitingState,
    WifiStatus status,
  ) {
    final currentState = state;
    if (currentState is! ProvisioningDeviceWiFiConnecting) {
      return;
    }

    switch (status) {
      case .idle:
        break;
      case .connecting:
        _logger.info(
          'Provisioning device is connecting to WiFi: '
          '$device',
        );
        break;
      case .connected:
        _logger.info(
          'Provisioning device connected to WiFi: '
          '$device',
        );
        state = ProvisioningDeviceRegisteringGateway(
          device,
          hardwareId: waitingState.hardwareId,
          inverterSn: waitingState.inverterSn,
        );
        _registerGateway();
        break;
      case .failed:
      case .error:
        _logger.severe(
          'Provisioning device failed to connect to WiFi: '
          '$device',
        );

        state = ProvisioningDeviceError(
          device,
          error: 'Failed to connect to WiFi',
          retryState: ProvisioningDeviceIdentityRead(
            currentState.device,
            hardwareId: currentState.hardwareId,
            inverterSn: currentState.inverterSn,
            ssid: _ssid,
            password: _password,
          ),
        );
        break;
    }
  }

  void _registerGateway() async {
    final currentState = state;
    if (currentState is! ProvisioningDeviceRegisteringGateway) {
      _logger.warning(
        'Cannot register gateway, '
        'state is mismatched: ${state.runtimeType}',
      );
      return;
    }

    try {
      // Call the registerGateway function in the database service.
      final response = await _db.registerGateway(
        GatewayRegistrationRequest(
          mode: .create,
          hardwareId: currentState.hardwareId,
          inverterSerialNumber: currentState.inverterSn,
          displayName: _displayName,
          location: _location,
        ), // Replace with actual inverter serial number
      );
      _logger.info(
        'Registered gateway for provisioning device: '
        '${currentState.device}',
      );
      state = ProvisioningDeviceWritingConfig(
        currentState.device,
        config: DeviceConfig(
          gatewayId: response.gatewayId,
          deviceSecret: response.deviceSecret,
          inverterId: response.inverterId,
          expectedInverterSn: response.inverterSerialNumber,
        ),
      );
      _writeDeviceConfig();
    } catch (e) {
      _logger.severe(
        'Failed to register gateway for provisioning device: '
        '${currentState.device}',
        e,
      );
      state = ProvisioningDeviceError(
        currentState.device,
        error: e.toString(),
        retryState: const ProvisioningScanning({}),
      );
    }
  }

  void _writeDeviceConfig() async {
    final currentState = state;
    if (currentState is! ProvisioningDeviceWritingConfig) {
      _logger.warning(
        'Cannot write device config, '
        'state is mismatched: ${state.runtimeType}',
      );
      return;
    }

    _logger.info(
      'Writing device config to provisioning device: '
      '${currentState.device}',
    );

    try {
      await _ble.writeCloudConfig(
        deviceId: currentState.device,
        supabaseUrl: _db.supabaseUrl,
      );
      _logger.info(
        'Wrote cloud config to provisioning device: '
        '${currentState.device}',
      );

      await _ble.writeDeviceConfig(currentState.device, currentState.config);
      _logger.info(
        'Successfully wrote device config to provisioning device: '
        '${currentState.device}',
      );

      // Stop listening to the connection as device is now fully provisioned
      // and about to turn off the BLE connection.
      _connectionSubscription?.cancel();
      state = const ProvisioningComplete();
    } catch (e) {
      _logger.severe(
        'Failed to write device config to provisioning device: '
        '${currentState.device}',
        e,
      );
      state = ProvisioningDeviceError(
        currentState.device,
        error: e.toString(),
        retryState: const ProvisioningScanning({}),
      );
    }
  }
}

abstract class ProvisioningState {
  const ProvisioningState();
}

class ProvisioningInformation extends ProvisioningState {
  const ProvisioningInformation();
}

class ProvisioningInitial extends ProvisioningState {
  const ProvisioningInitial();
}

class ProvisioningScanning extends ProvisioningState {
  final Set<String> devices;

  const ProvisioningScanning(this.devices);
}

class ProvisioningError extends ProvisioningState {
  final String error;

  const ProvisioningError(this.error);
}

class ProvisioningPermissionsError extends ProvisioningState {
  final String error;

  const ProvisioningPermissionsError(this.error);
}

abstract class ProvisioningDevice extends ProvisioningState {
  final String device;

  const ProvisioningDevice(this.device);
}

class ProvisioningDeviceConnecting extends ProvisioningDevice {
  const ProvisioningDeviceConnecting(super.device);
}

class ProvisioningDeviceConnected extends ProvisioningDevice {
  const ProvisioningDeviceConnected(super.device);
}

/// Device has been connected and is now disconnected.
///
/// This can happen if the device goes out of range or if the user disconnects
/// it.
class ProvisioningDeviceDisconnected extends ProvisioningDevice {
  const ProvisioningDeviceDisconnected(super.device);
}

class ProvisioningDeviceError extends ProvisioningDevice {
  final String error;

  final ProvisioningState retryState;

  const ProvisioningDeviceError(
    super.device, {
    required this.error,
    required this.retryState,
  });
}

/// Device connected and identity read successfully.
///
/// Waiting for the user to submit the WiFi credentials to the device.
class ProvisioningDeviceIdentityRead extends ProvisioningDevice {
  final String hardwareId;
  final String inverterSn;

  /// Not null if this is a retry after an error.
  final String? ssid;
  final String? password;

  const ProvisioningDeviceIdentityRead(
    super.device, {
    required this.hardwareId,
    required this.inverterSn,
    this.ssid,
    this.password,
  });
}

/// Device connected and WiFi credentials sent successfully.
///
/// Waiting for the device to connect to the WiFi network and report back its
/// status.
class ProvisioningDeviceWiFiConnecting extends ProvisioningDevice {
  final String hardwareId;
  final String inverterSn;

  const ProvisioningDeviceWiFiConnecting(
    super.device, {
    required this.hardwareId,
    required this.inverterSn,
  });
}

/// Device connected to WiFi
///
/// Gateway registration is in progress with server.
class ProvisioningDeviceRegisteringGateway extends ProvisioningDevice {
  final String hardwareId;
  final String inverterSn;

  const ProvisioningDeviceRegisteringGateway(
    super.device, {
    required this.hardwareId,
    required this.inverterSn,
  });
}

/// Gateway registered on server.
///
/// Device connfiguration is being written to device.
class ProvisioningDeviceWritingConfig extends ProvisioningDevice {
  final DeviceConfig config;

  const ProvisioningDeviceWritingConfig(super.device, {required this.config});
}

class ProvisioningComplete extends ProvisioningState {
  const ProvisioningComplete();
}
