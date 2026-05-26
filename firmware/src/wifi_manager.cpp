// WiFi manager: centralizes station mode setup and connection retries.

#include "wifi_manager.h"
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
    Serial.println("NVS init failed");
    return false;
  }

  String ssid;
  String password;
  if (!nvsGetWifiCredentials(ssid, password)) {
    Serial.println("WiFi credentials not provisioned in NVS");
    return false;
  }

  Serial.printf("WiFi connecting to %s ...\n", ssid.c_str());
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid.c_str(), password.c_str());

  uint32_t startMs = millis();
  while (!wifiManagerIsConnected() && (millis() - startMs) < WIFI_CONNECT_TIMEOUT_MS) {
    delay(250);
    Serial.print('.');
  }
  Serial.println();

  if (!wifiManagerIsConnected()) {
    Serial.println("WiFi connect failed");
    return false;
  }

  Serial.print("WiFi OK, IP=");
  Serial.println(WiFi.localIP());
  return true;
}

bool wifiManagerEnsureConnected() {
  return wifiManagerBegin();
}
