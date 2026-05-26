#pragma once

// WiFi manager: wraps connection logic, retries, and status reporting
// used by other modules (Supabase, OTA, BLE provisioning flow).

#include <Arduino.h>

bool wifiManagerBegin();
bool wifiManagerEnsureConnected();
bool wifiManagerIsConnected();
