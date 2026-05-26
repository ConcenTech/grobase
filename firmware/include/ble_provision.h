#pragma once

// BLE provisioning interface: GATT service for setup mode. The
// firmware will advertise a BLE service to receive WiFi credentials
// and a Supabase URL/credentials during initial provisioning.

#include <Arduino.h>

void bleProvisionBegin();
void bleProvisionPoll();

void bleProvisionSetHardwareId(const String &hardwareId);
void bleProvisionSetInverterSn(const String &inverterSn);
void bleProvisionSetWifiStatus(const String &status);
void bleProvisionSetStatus(const String &status);

bool bleProvisionApplyWifiConfigJson(const String &payload, String *outError = nullptr);
bool bleProvisionApplyCloudConfigJson(const String &payload, String *outError = nullptr);
bool bleProvisionApplyDeviceConfigJson(const String &payload, String *outError = nullptr);

bool bleProvisionConnectWifiFromNvs(uint32_t timeoutMs = 30000);
