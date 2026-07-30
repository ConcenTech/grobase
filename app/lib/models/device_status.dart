const List<String> _deviceWifiErrorStrings = [
  'wifi_failed',
  'wifi_missing',
  'nvs_failed',
  'missing_ssid',
  'wifi_error',
];

const List<String> _deviceCloudErrorStrings = [
  'missing_supabase_url',
  'invalid_supabase_url',
  'cloud_error',
];

const List<String> _deviceConfigErrorStrings = [
  'missing_device_config_fields',
  'device_error',
];

const List<String> _deviceGenericErrorStrings = [
  'invalid_json',
  'storage_failed',
];

enum DeviceStatus {
  // At identity read
  idl('idle', 'Ready'),
  advertising('advertising', 'Advertising'),
  snUnavailable('sn_unavailable', 'Serial number unavailable'),

  /// Wifi config has been written to the device.
  wifiConfigured('wifi_configured', 'Wifi configured'),

  /// Device is attempting to connect to the wifi network.
  wifiConnecting('wifi_connecting', 'Connecting to Wifi'),

  /// Device has successfully connected to the wifi network.
  wifiConnected('wifi_connected', 'Connected to Wifi'),

  /// Device failed to connect to the wifi network.
  /// For more details, read the status string directly.
  wifiFailed('wifi_failed', 'Failed to connect to Wifi'),

  /// Device has been configured with cloud settings.
  cloudConfigured('cloud_configured', 'Cloud configured'),

  /// Device failed to save the cloud configuration.
  /// For more details, read the status string directly.
  cloudFailed('cloud_error', 'Failed to configure cloud settings'),

  /// Device config has been written to the device.
  configured('device_configured', 'Gateway configured'),

  /// Device failed to save the device configuration.
  /// For more details, read the status string directly.
  configFailed('device_error', 'Failed to configure gateway'),

  /// Catchall for any status that doesn't match other value.
  /// Read the status string directly for more detailed information.
  other('', 'An unknown error occurred');

  final String value;

  final String humanised;

  const DeviceStatus(this.value, this.humanised);

  static DeviceStatus fromString(String statusString) {
    var status = DeviceStatus.values.firstWhere(
      (e) => e.value == statusString,
      orElse: () => DeviceStatus.other,
    );
    if (status == .other) {
      if (_deviceWifiErrorStrings.contains(statusString)) {
        status = .wifiFailed;
      } else if (_deviceCloudErrorStrings.contains(statusString)) {
        status = .cloudFailed;
      } else if (_deviceConfigErrorStrings.contains(statusString)) {
        status = .configFailed;
      } else if (_deviceGenericErrorStrings.contains(statusString)) {
        status = .other;
      }
    }
    return status;
  }
}

class DetailedDeviceStatus {
  final DeviceStatus status;
  final String detail;

  DetailedDeviceStatus(this.detail) : status = DeviceStatus.fromString(detail);
}
