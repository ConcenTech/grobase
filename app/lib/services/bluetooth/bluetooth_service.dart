// These are the 5 stages of the provisioning flow that requires BLE
// communication with the ESP32 setup device.
// 1	Scan for ESP32 setup device.
// 2	ESP returns inverter SN or error
// 3  Send WiFi credentials + Supabase URL to ESP
// 4	Wait for ESP BLE signal: WiFi connected (or failed)
// 4a	WiFi fail → ESP signals app → user sees error, fixes credentials.
// 5	App sends device credential + ids to ESP

import 'dart:async';
import 'dart:convert';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/device_config.dart';
import '../../models/device_status.dart';
import 'wifi_status.dart';

final bluetoothProvider = Provider.autoDispose(
  (ref) => BluetoothService(FlutterReactiveBle()),
);

class BleDevice {
  final String name;
  final String id;

  BleDevice(this.name, this.id);

  factory BleDevice.fromBle(DiscoveredDevice device) {
    return BleDevice(device.name, device.id);
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is BleDevice && other.id == id;
  }
}

class BluetoothService {
  const BluetoothService(this._ble);
  // ignore: unused_field
  final FlutterReactiveBle _ble;

  static final Uuid _setupServiceUuid = Uuid.parse(
    '2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d01',
  );
  static final Uuid _hardwareIdUuid = Uuid.parse(
    '2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d02',
  );
  static final Uuid _inverterSnUuid = Uuid.parse(
    '2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d03',
  );
  static final Uuid _wifiConfigUuid = Uuid.parse(
    '2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d04',
  );
  static final Uuid _cloudConfigUuid = Uuid.parse(
    '2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d05',
  );
  static final Uuid _deviceConfigUuid = Uuid.parse(
    '2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d06',
  );
  static final Uuid _wifiStatusUuid = Uuid.parse(
    '2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d07',
  );
  static final Uuid _statusUuid = Uuid.parse(
    '2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d08',
  );
  static const String _setupDeviceName = 'GroBase-Setup';

  // Starts scanning for the ESP32 setup device used during provisioning.
  Stream<BleDevice> provisioningStream() {
    return _ble
        .scanForDevices(
          // Must match connectToAdvertisingDevice's withServices so the
          // connector can hand off from an in-flight scan after we stop it.
          withServices: [_setupServiceUuid],
          scanMode: ScanMode.lowLatency,
        )
        .where((device) {
          return device.name == _setupDeviceName ||
              device.serviceUuids.contains(_setupServiceUuid);
        })
        .map((device) {
          return BleDevice.fromBle(device);
        });
  }

  Stream<ConnectionStateUpdate> connectionStream(String deviceId) {
    return _ble.connectToAdvertisingDevice(
      id: deviceId,
      withServices: [_setupServiceUuid],
      prescanDuration: const Duration(seconds: 2),
      servicesWithCharacteristicsToDiscover: {_setupServiceUuid: <Uuid>[]},
      connectionTimeout: const Duration(seconds: 10),
    );
  }

  // Identity and setup data.
  Future<DetailedDeviceStatus> readStatus(String deviceId) async {
    final statusString = await _readStringCharacteristic(deviceId, _statusUuid);
    return DetailedDeviceStatus(statusString);
  }

  // Reads the stable hardware ID exposed by the ESP32 over BLE.
  Future<String> readHardwareId(String deviceId) async {
    return _readStringCharacteristic(deviceId, _hardwareIdUuid);
  }

  // Reads the inverter serial number cached by the ESP32 at boot.
  Future<String> readInverterSerialNumber(String deviceId) async {
    return _readStringCharacteristic(deviceId, _inverterSnUuid);
  }

  // Writes the WiFi credentials that the ESP32 stores before it joins the network.
  Future<void> writeWifiConfig({
    required String deviceId,
    required String ssid,
    required String password,
  }) async {
    await _writeJsonCharacteristic(deviceId, _wifiConfigUuid, {
      'ssid': ssid,
      'password': password,
    });
  }

  // Writes the Supabase URL the ESP32 should use after provisioning.
  Future<void> writeCloudConfig({
    required String deviceId,
    required String supabaseUrl,
  }) async {
    await _writeJsonCharacteristic(deviceId, _cloudConfigUuid, {
      'supabase_url': supabaseUrl,
    });
  }

  // Writes the device credentials and inverter binding returned by register_gateway.
  Future<void> writeDeviceConfig(String deviceId, DeviceConfig config) async {
    await _writeJsonCharacteristic(deviceId, _deviceConfigUuid, {
      'gateway_id': config.gatewayId,
      'device_secret': config.deviceSecret,
      'inverter_id': config.inverterId,
      'expected_inverter_sn': config.expectedInverterSn,
    });
  }

  // Observability during setup.

  // Streams WiFi state notifications from the ESP32 during provisioning.
  Stream<WifiStatus> watchWifiStatus(String deviceId) {
    return _subscribeToStringCharacteristic(
      deviceId,
      _wifiStatusUuid,
    ).map(WifiStatus.fromString);
  }

  Future<WifiStatus> readWifiStatus(String deviceId) async {
    final statusString = await _readStringCharacteristic(
      deviceId,
      _wifiStatusUuid,
    );
    return WifiStatus.fromString(statusString);
  }

  // Streams general setup/status notifications from the ESP32.
  Stream<String> watchStatus(String deviceId) {
    return _subscribeToStringCharacteristic(deviceId, _statusUuid);
  }

  QualifiedCharacteristic _characteristic(
    String deviceId,
    Uuid characteristicId,
  ) {
    return QualifiedCharacteristic(
      serviceId: _setupServiceUuid,
      characteristicId: characteristicId,
      deviceId: deviceId,
    );
  }

  Future<String> _readStringCharacteristic(
    String deviceId,
    Uuid characteristicId,
  ) async {
    final bytes = await _ble.readCharacteristic(
      _characteristic(deviceId, characteristicId),
    );
    return utf8.decode(bytes).trim();
  }

  Future<void> _writeJsonCharacteristic(
    String deviceId,
    Uuid characteristicId,
    Map<String, dynamic> payload,
  ) async {
    await _ble.writeCharacteristicWithResponse(
      _characteristic(deviceId, characteristicId),
      value: utf8.encode(jsonEncode(payload)),
    );
  }

  Stream<String> _subscribeToStringCharacteristic(
    String deviceId,
    Uuid characteristicId,
  ) {
    return _ble
        .subscribeToCharacteristic(_characteristic(deviceId, characteristicId))
        .map((bytes) => utf8.decode(bytes).trim());
  }
}
