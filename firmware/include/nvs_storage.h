#pragma once

// NVS storage helpers: save/load device secrets, gateway id, and
// provisioning state. Wraps esp32 NVS access behind a small API.

#include <Arduino.h>

bool nvsBegin();

bool nvsGetWifiCredentials(String &outSsid, String &outPassword);
bool nvsSetWifiCredentials(const String &ssid, const String &password);

bool nvsGetDeviceSecret(String &outSecret);
bool nvsSetDeviceSecret(const String &secret);

bool nvsGetGatewayId(String &outId);
bool nvsSetGatewayId(const String &id);

bool nvsGetSupabaseUrl(String &outUrl);
bool nvsSetSupabaseUrl(const String &url);

bool nvsGetInverterId(String &outId);
bool nvsSetInverterId(const String &id);

bool nvsGetExpectedInverterSn(String &outSn);
bool nvsSetExpectedInverterSn(const String &sn);
