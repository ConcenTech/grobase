class DeviceConfig {
  final String gatewayId;
  final String deviceSecret;
  final String inverterId;
  final String expectedInverterSn;

  const DeviceConfig({
    required this.gatewayId,
    required this.deviceSecret,
    required this.inverterId,
    required this.expectedInverterSn,
  });
}
