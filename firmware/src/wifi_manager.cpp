// WiFi manager: centralizes station mode setup and connection retries.

#include "wifi_manager.h"
#include "debug_print.h"
#include "nvs_storage.h"

#include <WiFi.h>

static const uint32_t WIFI_CONNECT_TIMEOUT_MS = 30000;

bool wifiManagerIsConnected() {
  return WiFi.status() == WL_CONNECTED;
}

bool wifiManagerBegin() {
  if (wifiManagerIsConnected()) {
    return true;
  }

  if (!nvsBegin()) {
    DEBUG_PRINTLN("NVS init failed");
    return false;
  }

  String ssid;
  String password;
  if (!nvsGetWifiCredentials(ssid, password)) {
    DEBUG_PRINTLN("WiFi credentials not provisioned in NVS");
    return false;
  }

  DEBUG_PRINTF("WiFi connecting to %s ...\n", ssid.c_str());
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid.c_str(), password.c_str());

  uint32_t startMs = millis();
  while (!wifiManagerIsConnected() && (millis() - startMs) < WIFI_CONNECT_TIMEOUT_MS) {
    delay(250);
    DEBUG_PRINT('.');
  }
  DEBUG_PRINTLN();

  if (!wifiManagerIsConnected()) {
    DEBUG_PRINTLN("WiFi connect failed");
    return false;
  }

  DEBUG_PRINT("WiFi OK, IP=");
  DEBUG_PRINTLN(WiFi.localIP());
  return true;
}

bool wifiManagerEnsureConnected() {
  return wifiManagerBegin();
}
