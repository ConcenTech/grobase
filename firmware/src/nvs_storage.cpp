// NVS storage: persists provisioning data, gateway identity, and WiFi settings.

#include "nvs_storage.h"

#include "debug_print.h"
#include <Preferences.h>

static Preferences g_prefs;
static bool g_nvsOpen = false;
static const char *NVS_NAMESPACE = "grobase";
static const char *KEY_WIFI_SSID = "wifi_ssid";
static const char *KEY_WIFI_PASSWORD = "wifi_pass";
static const char *KEY_DEVICE_SECRET = "device_secret";
static const char *KEY_GATEWAY_ID = "gateway_id";
static const char *KEY_SUPABASE_URL = "supabase_url";
// static const char *KEY_SUPABASE_ANON_KEY = "supabase_anon";
static const char *KEY_INVERTER_ID = "inverter_id";
static const char *KEY_EXPECTED_INVERTER_SN = "expected_sn";

bool nvsBegin() {
  if (g_nvsOpen) {
    return true;
  }
  g_nvsOpen = g_prefs.begin(NVS_NAMESPACE, false);
  return g_nvsOpen;
}

bool nvsGetWifiCredentials(String &outSsid, String &outPassword) {
  if (!g_prefs.isKey(KEY_WIFI_SSID) || !g_prefs.isKey(KEY_WIFI_PASSWORD)) {
    return false;
  }
  outSsid = g_prefs.getString(KEY_WIFI_SSID, "");
  outPassword = g_prefs.getString(KEY_WIFI_PASSWORD, "");
  return outSsid.length() > 0;
}

bool nvsSetWifiCredentials(const String &ssid, const String &password) {
  if (ssid.length() == 0) {
    return false;
  }
  g_prefs.putString(KEY_WIFI_SSID, ssid);
  g_prefs.putString(KEY_WIFI_PASSWORD, password);
  DEBUG_PRINTF("NVS: wifi credentials stored for ssid=%s\n", ssid.c_str());
  return true;
}

bool nvsGetDeviceSecret(String &outSecret) {
  if (!g_prefs.isKey(KEY_DEVICE_SECRET)) {
    return false;
  }
  outSecret = g_prefs.getString(KEY_DEVICE_SECRET, "");
  return outSecret.length() > 0;
}

bool nvsSetDeviceSecret(const String &secret) {
  if (secret.length() == 0) {
    return false;
  }
  g_prefs.putString(KEY_DEVICE_SECRET, secret);
  DEBUG_PRINTLN("NVS: device secret stored");
  return true;
}

bool nvsGetGatewayId(String &outId) {
  if (!g_prefs.isKey(KEY_GATEWAY_ID)) {
    return false;
  }
  outId = g_prefs.getString(KEY_GATEWAY_ID, "");
  return outId.length() > 0;
}

bool nvsSetGatewayId(const String &id) {
  if (id.length() == 0) {
    return false;
  }
  g_prefs.putString(KEY_GATEWAY_ID, id);
  DEBUG_PRINTF("NVS: gateway_id stored (%s)\n", id.c_str());
  return true;
}

bool nvsGetSupabaseUrl(String &outUrl) {
  if (!g_prefs.isKey(KEY_SUPABASE_URL)) {
    return false;
  }
  outUrl = g_prefs.getString(KEY_SUPABASE_URL, "");
  return outUrl.length() > 0;
}

bool nvsSetSupabaseUrl(const String &url) {
  if (url.length() == 0) {
    return false;
  }
  g_prefs.putString(KEY_SUPABASE_URL, url);
  DEBUG_PRINTF("NVS: supabase_url stored (%s)\n", url.c_str());
  return true;
}

bool nvsGetInverterId(String &outId) {
  if (!g_prefs.isKey(KEY_INVERTER_ID)) {
    return false;
  }
  outId = g_prefs.getString(KEY_INVERTER_ID, "");
  return outId.length() > 0;
}

bool nvsSetInverterId(const String &id) {
  if (id.length() == 0) {
    return false;
  }
  g_prefs.putString(KEY_INVERTER_ID, id);
  DEBUG_PRINTF("NVS: inverter_id stored (%s)\n", id.c_str());
  return true;
}

bool nvsGetExpectedInverterSn(String &outSn) {
  if (!g_prefs.isKey(KEY_EXPECTED_INVERTER_SN)) {
    return false;
  }
  outSn = g_prefs.getString(KEY_EXPECTED_INVERTER_SN, "");
  return outSn.length() > 0;
}

bool nvsSetExpectedInverterSn(const String &sn) {
  if (sn.length() == 0) {
    return false;
  }
  g_prefs.putString(KEY_EXPECTED_INVERTER_SN, sn);
  DEBUG_PRINTF("NVS: expected_inverter_sn stored (%s)\n", sn.c_str());
  return true;
}
