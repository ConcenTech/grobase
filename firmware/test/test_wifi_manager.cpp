#include <unity.h>

#include "wifi_manager.h"
#include "nvs_storage.h"
#include <Preferences.h>
#include <WiFi.h>

void setUp(void) {
  Preferences p;
  p.begin("grobase", false);
  p.remove("wifi_ssid");
  p.remove("wifi_pass");
  p.remove("device_secret");
  p.remove("gateway_id");
  p.end();
  nvsBegin();
  WiFi.disconnect(true);
}

void tearDown(void) {
}

void test_wifi_manager_no_credentials_returns_false() {
  // With NVS cleared, wifiManagerBegin should return false quickly
  TEST_ASSERT_FALSE(wifiManagerBegin());
}

void test_wifi_manager_is_connected_initially_false() {
  TEST_ASSERT_FALSE(wifiManagerIsConnected());
}

int main(int argc, char **argv) {
  UNITY_BEGIN();

  RUN_TEST(test_wifi_manager_no_credentials_returns_false);
  RUN_TEST(test_wifi_manager_is_connected_initially_false);

  return UNITY_END();
}
