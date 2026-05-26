#include <unity.h>

#include "ble_provision.h"
#include "nvs_storage.h"
#include <Preferences.h>

static void clearProvisioningKeys() {
  Preferences prefs;
  prefs.begin("grobase", false);
  prefs.remove("wifi_ssid");
  prefs.remove("wifi_pass");
  prefs.remove("device_secret");
  prefs.remove("gateway_id");
  prefs.remove("supabase_url");
  prefs.remove("inverter_id");
  prefs.remove("expected_sn");
  prefs.end();
}

void setUp(void) {
  clearProvisioningKeys();
  nvsBegin();
}

void tearDown(void) {
}

void test_ble_provision_applies_wifi_cloud_and_device_json() {
  String error;

  TEST_ASSERT_TRUE(bleProvisionApplyWifiConfigJson(R"({"ssid":"Home WiFi","password":"secret pass"})", &error));
  TEST_ASSERT_EQUAL_UINT(0, error.length());

  String ssid;
  String password;
  TEST_ASSERT_TRUE(nvsGetWifiCredentials(ssid, password));
  TEST_ASSERT_EQUAL_STRING("Home WiFi", ssid.c_str());
  TEST_ASSERT_EQUAL_STRING("secret pass", password.c_str());

  TEST_ASSERT_TRUE(bleProvisionApplyCloudConfigJson(R"({"supabase_url":"https://example.supabase.co"})", &error));
  TEST_ASSERT_EQUAL_UINT(0, error.length());

  String url;
  TEST_ASSERT_TRUE(nvsGetSupabaseUrl(url));
  TEST_ASSERT_EQUAL_STRING("https://example.supabase.co", url.c_str());

  TEST_ASSERT_TRUE(bleProvisionApplyDeviceConfigJson(R"({"gateway_id":"gw-123","device_secret":"topsecret","inverter_id":"11111111-2222-3333-4444-555555555555","expected_inverter_sn":"abc1234567"})", &error));
  TEST_ASSERT_EQUAL_UINT(0, error.length());

  String gatewayId;
  String deviceSecret;
  String inverterId;
  String expectedSn;
  TEST_ASSERT_TRUE(nvsGetGatewayId(gatewayId));
  TEST_ASSERT_TRUE(nvsGetDeviceSecret(deviceSecret));
  TEST_ASSERT_TRUE(nvsGetInverterId(inverterId));
  TEST_ASSERT_TRUE(nvsGetExpectedInverterSn(expectedSn));
  TEST_ASSERT_EQUAL_STRING("gw-123", gatewayId.c_str());
  TEST_ASSERT_EQUAL_STRING("topsecret", deviceSecret.c_str());
  TEST_ASSERT_EQUAL_STRING("11111111-2222-3333-4444-555555555555", inverterId.c_str());
  TEST_ASSERT_EQUAL_STRING("ABC1234567", expectedSn.c_str());
}

void test_ble_provision_rejects_invalid_json() {
  String error;
  TEST_ASSERT_FALSE(bleProvisionApplyWifiConfigJson(R"({"password":"secret"})", &error));
  TEST_ASSERT_TRUE(error.length() > 0);
}

int main(int argc, char **argv) {
  UNITY_BEGIN();

  RUN_TEST(test_ble_provision_applies_wifi_cloud_and_device_json);
  RUN_TEST(test_ble_provision_rejects_invalid_json);

  return UNITY_END();
}