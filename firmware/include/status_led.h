
#include <Arduino.h>

enum class StatusLed {
  // Status, long blinks (count = blinks per sequence)
  BOOT,            // 2
  SETUP,           // 3
  WIFI_CONNECTING, // 4
  PROVISIONING,    // 5
  // Status, solid on
  PROVISIONED,
  // Fault, short blinks (count = blinks per sequence)
  SN_READ_FAILED,   // 2
  WIFI_FAILED,      // 3
  SN_MISMATCH,      // 4
  PROVISION_FAILED, // 5
  CLOUD_UNREACHABLE, // 6
  MODBUS_FAILED    // 7
};


void setStatusLed(StatusLed newState);
void initStatusLed();