enum WifiStatus {
  idle,
  connecting,
  connected,
  failed,

  /// This is not an expected state but, if the device responds with anything
  /// other than the above states, we will treat it as an error.
  error;

  static WifiStatus fromString(String status) {
    return WifiStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => WifiStatus.error,
    );
  }
}
