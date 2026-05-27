#// Minimal Supabase client for ESP32: WiFi connection, password grant
#// authentication, and REST `inverter_snapshots` insertion.
#include "supabase_client.h"

#include <WiFiClientSecure.h>
#include <HTTPClient.h>
#include <time.h>

#include "wifi_manager.h"
#include "nvs_storage.h"

#if __has_include("supabase_root_ca.h")
#include "supabase_root_ca.h"
#else
#error "Please provide your Supabase root CA certificate"

// Supabase URL and anon key are provided by the app during provisioning and
// stored in NVS; do not rely on a local `secrets.h` file.

static const uint32_t HTTP_TIMEOUT_MS = 20000;

static bool syncTimeNtp() {
  configTime(0, 0, "pool.ntp.org", "time.nist.gov");
  struct tm timeinfo;
  for (int i = 0; i < 20; i++) {
    if (getLocalTime(&timeinfo, 1000)) {
      return true;
    }
  }
  Serial.println("NTP sync failed (recorded_at will use DB default)");
  return false;
}

static String jsonEscape(const char *s) {
  String out;
  out.reserve(strlen(s) + 8);
  for (const char *p = s; *p; p++) {
    if (*p == '"' || *p == '\\') {
      out += '\\';
    }
    out += *p;
  }
  return out;
}
static bool httpPostJsonWithDeviceAuth(const String &url,
                                      const String &jsonBody,
                                      const String &gatewayId,
                                      const String &deviceSecret,
                                      const String &anonKey,
                                      int *outStatus,
                                      String *outBody) {
  WiFiClientSecure client;
    client.setCACert(SUPABASE_ROOT_CA_PEM);

  HTTPClient http;
  http.setTimeout(HTTP_TIMEOUT_MS);
  if (!http.begin(client, url)) {
    Serial.println("HTTP begin failed");
    return false;
  }

  http.addHeader("Content-Type", "application/json");
  http.addHeader("apikey", anonKey);
  if (gatewayId.length() > 0 && deviceSecret.length() > 0) {
    http.addHeader("x-gateway-id", gatewayId);
    http.addHeader("x-device-secret", deviceSecret);
  }

  int code = http.POST(jsonBody);
  if (outStatus) {
    *outStatus = code;
  }
  if (outBody) {
    *outBody = http.getString();
  }
  http.end();
  return code > 0;
}

bool supabaseBegin() {
  if (!wifiManagerBegin()) {
    return false;
  }
  // Ensure NVS available and verify device provisioned
  nvsBegin();
  String baseUrl;
  String gwId;
  String devSecret;
  if (!nvsGetSupabaseUrl(baseUrl) || !nvsGetGatewayId(gwId) || !nvsGetDeviceSecret(devSecret)) {
    Serial.println("Supabase client: device not provisioned (missing URL or device creds)");
    return false;
  }
  syncTimeNtp();
  return true;
}

bool supabaseEnsureAuth() {
  // No JWT-based auth on device: ensure WiFi and device creds present
  if (!wifiManagerEnsureConnected()) return false;
  String gwId;
  String devSecret;
  if (!nvsGetGatewayId(gwId) || !nvsGetDeviceSecret(devSecret)) return false;
  return true;
}

static String buildSnapshotJson(const InverterSnapshot *s) {
  String deviceId;
  if (!nvsGetGatewayId(deviceId) || deviceId.length() == 0) {
    deviceId = String(DEVICE_ID);
  }

  String j;
  j.reserve(900);
  j += "{";
  j += "\"device_id\":\"" + jsonEscape(deviceId.c_str()) + "\",";
  j += "\"modbus_ok\":";
  j += s->modbus_ok ? "true" : "false";
  j += ",\"battery_discharge_power_w\":";
  j += String(s->battery_discharge_power_w, 1);
  j += ",\"battery_charge_power_w\":";
  j += String(s->battery_charge_power_w, 1);
  j += ",\"vbat\":";
  j += String(s->vbat, 1);
  j += ",\"vbat_dsp\":";
  j += String(s->vbat_dsp, 1);
  j += ",\"soc_1014\":";
  j += String(s->soc_1014, 0);
  j += ",\"bms_soc\":";
  j += String(s->bms_soc, 0);
  j += ",\"bms_battery_volt\":";
  j += String(s->bms_battery_volt, 1);
  j += ",\"bms_battery_curr\":";
  j += String(s->bms_battery_curr, 1);
  j += ",\"battery_discharge_energy_today_kwh\":";
  j += String(s->battery_discharge_energy_today_kwh, 1);
  j += ",\"battery_charge_energy_today_kwh\":";
  j += String(s->battery_charge_energy_today_kwh, 1);
  j += ",\"grid_pac_w\":";
  j += String(s->grid_pac_w, 1);
  j += ",\"grid_frequency_hz\":";
  j += String(s->grid_frequency_hz, 2);
  j += ",\"grid_voltage_v\":";
  j += String(s->grid_voltage_v, 1);
  j += ",\"grid_current_a\":";
  j += String(s->grid_current_a, 1);
  j += ",\"power_to_grid_w\":";
  j += String(s->power_to_grid_w, 1);
  j += ",\"energy_to_grid_today_kwh\":";
  j += String(s->energy_to_grid_today_kwh, 1);
  j += ",\"ac_charge_energy_today_kwh\":";
  j += String(s->ac_charge_energy_today_kwh, 1);
  j += ",\"ac_charge_power_w\":";
  j += String(s->ac_charge_power_w, 1);
  j += ",\"eac_today_kwh\":";
  j += String(s->eac_today_kwh, 1);
  j += ",\"ea_charge_today_kwh\":";
  j += String(s->ea_charge_today_kwh, 1);
  j += ",\"ac_charge_power_spa_w\":";
  j += String(s->ac_charge_power_spa_w, 1);
  j += ",\"pv_energy_today_kwh\":";
  j += String(s->pv_energy_today_kwh, 1);
  j += ",\"power_to_user_w\":";
  j += String(s->power_to_user_w, 1);
  j += ",\"local_load_power_w\":";
  j += String(s->local_load_power_w, 1);
  j += "}";
  return j;
}

bool supabaseInsertSnapshot(const InverterSnapshot *snapshot) {
  if (!supabaseEnsureAuth()) return false;

  String baseUrl;
  if (!nvsGetSupabaseUrl(baseUrl)) {
    Serial.println("Supabase insert: supabase URL not provisioned");
    return false;
  }
  String url = baseUrl + "/functions/v1/ingest_snapshot";
  String body = buildSnapshotJson(snapshot);

  String gwId;
  String devSecret;
  if (!nvsGetGatewayId(gwId) || !nvsGetDeviceSecret(devSecret)) {
    Serial.println("Supabase insert: missing gateway credentials");
    return false;
  }

  String anonKey;
  if (!nvsGetSupabaseAnonKey(anonKey)) {
    Serial.println("Supabase insert: anon key not provisioned");
    return false;
  }

  const int maxAttempts = 3;
  for (int attempt = 1; attempt <= maxAttempts; ++attempt) {
    int status = 0;
    String response;
    if (!httpPostJsonWithDeviceAuth(url, body, gwId, devSecret, anonKey, &status, &response)) {
      if (attempt == maxAttempts) return false;
      delay(200 * attempt);
      continue;
    }

    if (status >= 200 && status < 300) {
      Serial.println("Supabase insert OK");
      return true;
    }

    if (status == 401) {
      Serial.println("Supabase insert: invalid device credentials");
      return false;
    }

    Serial.printf("Supabase insert failed HTTP %d: %s\n", status, response.c_str());
    if (status >= 500 || status <= 0) {
      if (attempt < maxAttempts) delay(500 * attempt);
      continue;
    }

    return false;
  }
  return false;
}
