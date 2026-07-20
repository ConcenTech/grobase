#// Minimal Supabase client for ESP32: WiFi connection, password grant
#// authentication, and REST `inverter_snapshots` insertion.
#include "supabase_client.h"
#if DEBUG_MODE
#include <WiFiClient.h>
#else
#include <WiFiClientSecure.h>
#endif
#include <HTTPClient.h>
#include <time.h>

#include "wifi_manager.h"
#include "nvs_storage.h"
#include "debug_print.h"

#if __has_include("../include/supabase_root_ca.h")
#include "../include/supabase_root_ca.h"
#elif __has_include("supabase_root_ca.h")
#include "supabase_root_ca.h"
#else
#error "Please provide your Supabase root CA certificate"
#endif



// Supabase URL is provided by the app during provisioning and
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
  DEBUG_PRINTLN("NTP sync failed (recorded_at will use DB default)");
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

static String iso8601Now() {
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo, 100)) {
    return "";
  }
  char buf[25];
  strftime(buf, sizeof(buf), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);
  return String(buf);
}

static void appendJsonNumber(String &j, const char *key, float value, uint8_t decimals) {
  char buf[24];
  snprintf(buf, sizeof(buf), "%.*f", static_cast<int>(decimals), static_cast<double>(value));
  j += ",\"";
  j += key;
  j += "\":";
  j += buf;
}
static bool httpPostJsonWithDeviceAuth(const String &url,
                                      const String &jsonBody,
                                      const String &gatewayId,
                                      const String &deviceSecret,
                                      int *outStatus,
                                      String *outBody) {
  #if DEBUG_MODE
    DEBUG_PRINTLN("Supabase client: using insecure WiFiClient for testing");
    WiFiClient client;
  #else
    WiFiClientSecure client;
    client.setCACert(SUPABASE_ROOT_CA_PEM);
  #endif

  DEBUG_PRINTLN("Supabase client: POST " + url + " body=" + jsonBody);
  
  HTTPClient http;
  http.setTimeout(HTTP_TIMEOUT_MS);
  if (!http.begin(client, url)) {
    DEBUG_PRINTLN("HTTP begin failed");
    return false;
  }

  http.addHeader("Content-Type", "application/json");
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
    DEBUG_PRINTLN("Supabase client: device not provisioned (missing URL or device creds)");
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

static String buildSnapshotJson(const InverterSnapshot *s,
                              const String &inverterId,
                              const String &recordedAt) {
  String j;
  j.reserve(900);
  j += "{";
  j += "\"inverter_id\":\"" + jsonEscape(inverterId.c_str()) + "\"";
  j += ",\"recorded_at\":\"" + jsonEscape(recordedAt.c_str()) + "\"";

  const float batterySoc =
      s->bms_soc > 0.0f ? s->bms_soc : s->soc_1014;
  const float batteryVoltage =
      s->vbat_dsp > 0.0f ? s->vbat_dsp :
      (s->vbat > 0.0f ? s->vbat : s->bms_battery_volt);

  appendJsonNumber(j, "battery_soc_percent", batterySoc, 0);
  appendJsonNumber(j, "battery_voltage_v", batteryVoltage, 1);
  appendJsonNumber(j, "battery_current_a", s->bms_battery_curr, 1);
  appendJsonNumber(j, "battery_charge_power_w", s->battery_charge_power_w, 1);
  appendJsonNumber(j, "battery_discharge_power_w", s->battery_discharge_power_w, 1);
  appendJsonNumber(j, "battery_charge_energy_today_kwh", s->battery_charge_energy_today_kwh, 1);
  appendJsonNumber(j, "battery_discharge_energy_today_kwh", s->battery_discharge_energy_today_kwh, 1);
  // grid_active_power_w is grid import (PactouserTotal). Pac is inverter output
  // and must not be used here — the app treats active − export as net grid power.
  appendJsonNumber(j, "grid_active_power_w", s->power_to_user_w, 1);
  appendJsonNumber(j, "grid_frequency_hz", s->grid_frequency_hz, 2);
  appendJsonNumber(j, "grid_voltage_v", s->grid_voltage_v, 1);
  appendJsonNumber(j, "grid_current_a", s->grid_current_a, 1);
  appendJsonNumber(j, "grid_export_power_w", s->power_to_grid_w, 1);
  appendJsonNumber(j, "grid_export_energy_today_kwh", s->energy_to_grid_today_kwh, 1);
  appendJsonNumber(j, "grid_import_energy_today_kwh", s->ac_charge_energy_today_kwh, 1);
  appendJsonNumber(j, "grid_charge_power_w", s->ac_charge_power_spa_w, 1);
  appendJsonNumber(j, "solar_energy_today_kwh", s->eextra_today_kwh, 1);
  appendJsonNumber(j, "solar_power_w", s->extra_ac_power_w, 1);
  appendJsonNumber(j, "home_load_power_w", s->local_load_power_w, 1);

  j += "}";
  return j;
}

bool supabaseInsertSnapshot(const InverterSnapshot *snapshot) {
  if (!supabaseEnsureAuth()) return false;

  String baseUrl;
  if (!nvsGetSupabaseUrl(baseUrl)) {
    DEBUG_PRINTLN("Supabase insert: supabase URL not provisioned");
    return false;
  }
  String gwId;
  String devSecret;
  String inverterId;
  if (!nvsGetGatewayId(gwId) || !nvsGetDeviceSecret(devSecret) ||
      !nvsGetInverterId(inverterId)) {
    DEBUG_PRINTLN("Supabase insert: missing gateway credentials");
    return false;
  }

  String recordedAt = iso8601Now();
  if (recordedAt.length() == 0) {
    syncTimeNtp();
    recordedAt = iso8601Now();
  }
  if (recordedAt.length() == 0) {
    DEBUG_PRINTLN("Supabase insert: recorded_at unavailable (NTP not synced)");
    return false;
  }

  String url = baseUrl + "/functions/v1/ingest_snapshot";
  String body = buildSnapshotJson(snapshot, inverterId, recordedAt);

  const int maxAttempts = 3;
  for (int attempt = 1; attempt <= maxAttempts; ++attempt) {
    int status = 0;
    String response;
    if (!httpPostJsonWithDeviceAuth(url, body, gwId, devSecret, &status, &response)) {
      if (attempt == maxAttempts) return false;
      delay(200 * attempt);
      continue;
    }

    if (status >= 200 && status < 300) {
      DEBUG_PRINTLN("Supabase insert OK");
      return true;
    }

    if (status == 401) {
      DEBUG_PRINTLN("Supabase insert: invalid device credentials");
      return false;
    }

    DEBUG_PRINTLN("Supabase insert failed HTTP " + String(status) + ": " + response);
    if (status >= 500 || status <= 0) {
      if (attempt < maxAttempts) delay(500 * attempt);
      continue;
    }

    return false;
  }
  return false;
}

static String buildEventJson(const String &inverterId,
                            const String &code,
                            const String &level,
                            const String &message,
                            const String &metadata) {
  String j;
  j.reserve(256);
  j += "{";
  j += "\"inverter_id\":\"" + jsonEscape(inverterId.c_str()) + "\"";
  if (code.length() > 0) {
    j += ",\"code\":\"" + jsonEscape(code.c_str()) + "\"";
  }
  if (level.length() > 0) {
    j += ",\"level\":\"" + jsonEscape(level.c_str()) + "\"";
  }
  if (message.length() > 0) {
    j += ",\"message\":\"" + jsonEscape(message.c_str()) + "\"";
  }
  if (metadata.length() > 0) {
    // If metadata appears to be a JSON object (starts with { or [), embed it raw, else JSON-escape string
    char first = metadata.charAt(0);
    if (first == '{' || first == '[') {
      j += ",\"metadata\":" + metadata;
    } else {
      j += ",\"metadata\":\"" + jsonEscape(metadata.c_str()) + "\"";
    }
  }
  j += "}";
  return j;
}

bool supabaseInsertEvent(const String &inverterId,
                         const String &code,
                         const String &level,
                         const String &message,
                         const String &metadata) {
  if (!supabaseEnsureAuth()) return false;

  String baseUrl;
  if (!nvsGetSupabaseUrl(baseUrl)) {
    DEBUG_PRINTLN("Supabase event: supabase URL not provisioned");
    return false;
  }

  String gwId;
  String devSecret;
  if (!nvsGetGatewayId(gwId) || !nvsGetDeviceSecret(devSecret)) {
    DEBUG_PRINTLN("Supabase event: missing gateway credentials");
    return false;
  }

  String url = baseUrl + "/functions/v1/ingest_event";
  String body = buildEventJson(inverterId, code, level, message, metadata);

  const int maxAttempts = 3;
  for (int attempt = 1; attempt <= maxAttempts; ++attempt) {
    int status = 0;
    String response;
    if (!httpPostJsonWithDeviceAuth(url, body, gwId, devSecret, &status, &response)) {
      DEBUG_PRINTLN("Supabase event: HTTP post failed (attempt " + String(attempt) + ")");
      if (attempt == maxAttempts) return false;
      delay(200 * attempt);
      continue;
    }

    if (status >= 200 && status < 300) {
      DEBUG_PRINTLN("Supabase event OK");
      return true;
    }

    if (status == 401) {
      DEBUG_PRINTLN("Supabase event: invalid device credentials");
      return false;
    }

    DEBUG_PRINTLN("Supabase event failed HTTP " + String(status) + ": " + response);
    if (status >= 500 || status <= 0) {
      if (attempt < maxAttempts) delay(500 * attempt);
      continue;
    }

    return false;
  }
  return false;
}
