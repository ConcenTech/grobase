// NVS storage: persists provisioning data, gateway identity, and WiFi settings.

#include "nvs_storage.h"

#include <Preferences.h>

static Preferences g_prefs;
static const char *NVS_NAMESPACE = "grobase";
static const char *KEY_WIFI_SSID = "wifi_ssid";
static const char *KEY_WIFI_PASSWORD = "wifi_pass";
static const char *KEY_DEVICE_SECRET = "device_secret";
static const char *KEY_GATEWAY_ID = "gateway_id";

bool nvsBegin() {
  return g_prefs.begin(NVS_NAMESPACE, false);
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
  return true;
}
