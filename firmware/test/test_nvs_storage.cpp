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
  p.remove("supabase_url");
  p.remove("inverter_id");
  p.remove("expected_sn");
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

void test_nvs_set_and_get_provisioning_fields() {
  TEST_ASSERT_TRUE(nvsSetSupabaseUrl("https://example.supabase.co"));
  String url;
  TEST_ASSERT_TRUE(nvsGetSupabaseUrl(url));
  TEST_ASSERT_EQUAL_STRING("https://example.supabase.co", url.c_str());

  TEST_ASSERT_TRUE(nvsSetInverterId("11111111-2222-3333-4444-555555555555"));
  String inverterId;
  TEST_ASSERT_TRUE(nvsGetInverterId(inverterId));
  TEST_ASSERT_EQUAL_STRING("11111111-2222-3333-4444-555555555555", inverterId.c_str());

  TEST_ASSERT_TRUE(nvsSetExpectedInverterSn("abc1234567"));
  String sn;
  TEST_ASSERT_TRUE(nvsGetExpectedInverterSn(sn));
  TEST_ASSERT_EQUAL_STRING("abc1234567", sn.c_str());
}

void test_nvs_begin_is_idempotent() {
  TEST_ASSERT_TRUE(nvsBegin());
  TEST_ASSERT_TRUE(nvsBegin());
  TEST_ASSERT_TRUE(nvsSetWifiCredentials("repeat_ssid", "repeat_pass"));
}

int main(int argc, char **argv) {
  UNITY_BEGIN();

  RUN_TEST(test_nvs_begin_is_idempotent);
  RUN_TEST(test_nvs_set_and_get_wifi);
  RUN_TEST(test_nvs_set_and_get_device_and_gateway);
  RUN_TEST(test_nvs_set_and_get_provisioning_fields);

  return UNITY_END();
}
