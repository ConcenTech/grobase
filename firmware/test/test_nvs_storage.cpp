#include <unity.h>

#include "nvs_storage.h"
#include <Preferences.h>

void setUp(void) {
  Preferences p;
  p.begin("grobase", false);
  p.remove("wifi_ssid");
  p.remove("wifi_pass");
  p.remove("device_secret");
  p.remove("gateway_id");
  p.end();
  // Ensure nvs wrapper is initialized
  nvsBegin();
}

void tearDown(void) {
}

void test_nvs_set_and_get_wifi() {
  TEST_ASSERT_TRUE(nvsSetWifiCredentials("test_ssid", "test_pass"));

  String ssid;
  String pass;
  TEST_ASSERT_TRUE(nvsGetWifiCredentials(ssid, pass));
  TEST_ASSERT_EQUAL_STRING("test_ssid", ssid.c_str());
  TEST_ASSERT_EQUAL_STRING("test_pass", pass.c_str());
}

void test_nvs_set_and_get_device_and_gateway() {
  TEST_ASSERT_TRUE(nvsSetDeviceSecret("secret123"));
  String secret;
  TEST_ASSERT_TRUE(nvsGetDeviceSecret(secret));
  TEST_ASSERT_EQUAL_STRING("secret123", secret.c_str());

  TEST_ASSERT_TRUE(nvsSetGatewayId("gw-42"));
  String gid;
  TEST_ASSERT_TRUE(nvsGetGatewayId(gid));
  TEST_ASSERT_EQUAL_STRING("gw-42", gid.c_str());
}

int main(int argc, char **argv) {
  UNITY_BEGIN();

  RUN_TEST(test_nvs_set_and_get_wifi);
  RUN_TEST(test_nvs_set_and_get_device_and_gateway);

  return UNITY_END();
}
