#include "ble_provision.h"

#include "nvs_storage.h"
#include "status_led.h"

#include <ArduinoJson.h>
#include <NimBLEDevice.h>
#include <WiFi.h>
#include "debug_print.h"

namespace {

constexpr char kServiceUuid[] = "2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d01";
constexpr char kHardwareIdUuid[] = "2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d02";
constexpr char kInverterSnUuid[] = "2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d03";
constexpr char kWifiConfigUuid[] = "2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d04";
constexpr char kCloudConfigUuid[] = "2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d05";
constexpr char kDeviceConfigUuid[] = "2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d06";
constexpr char kWifiStatusUuid[] = "2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d07";
constexpr char kStatusUuid[] = "2b0f6e76-9e91-4a1f-8d4f-9f1f7b2c2d08";

NimBLEServer *g_server = nullptr;
NimBLECharacteristic *g_hardwareIdChar = nullptr;
NimBLECharacteristic *g_inverterSnChar = nullptr;
NimBLECharacteristic *g_wifiConfigChar = nullptr;
NimBLECharacteristic *g_cloudConfigChar = nullptr;
NimBLECharacteristic *g_deviceConfigChar = nullptr;
NimBLECharacteristic *g_wifiStatusChar = nullptr;
NimBLECharacteristic *g_statusChar = nullptr;
bool g_started = false;

String g_pendingWifiConfigPayload;
volatile bool g_hasPendingWifiConfig = false;

enum class WifiConnectPhase : uint8_t {
  None,
  Pending,
  InProgress,
};

WifiConnectPhase g_wifiConnectPhase = WifiConnectPhase::None;
uint32_t g_wifiConnectStartedMs = 0;
uint32_t g_wifiConnectTimeoutMs = 30000;

String g_hardwareId;
String g_inverterSn;
String g_wifiStatus = "idle";
String g_status = "idle";

String trimCopy(const String &value) {
  String out = value;
  out.trim();
  return out;
}

String normalizeSerialNumber(const String &value) {
  String out = trimCopy(value);
  out.toUpperCase();
  return out;
}

String efuseMacAsString() {
  char out[18];
  uint64_t mac = ESP.getEfuseMac();
  snprintf(out, sizeof(out), "%02X:%02X:%02X:%02X:%02X:%02X",
           (uint8_t)((mac >> 40) & 0xFF), (uint8_t)((mac >> 32) & 0xFF),
           (uint8_t)((mac >> 24) & 0xFF), (uint8_t)((mac >> 16) & 0xFF),
           (uint8_t)((mac >> 8) & 0xFF), (uint8_t)(mac & 0xFF));
  return String(out);
}

bool readStringField(JsonDocument &doc, const char *key, String &out) {
  JsonVariantConst value = doc[key];
  if (value.isNull()) {
    return false;
  }

  const char *raw = value.as<const char *>();
  if (raw == nullptr) {
    return false;
  }

  out = raw;
  out.trim();
  return out.length() > 0;
}

void updateCharacteristic(NimBLECharacteristic *characteristic,
                          const String &value, bool notify) {
  if (characteristic == nullptr) {
    return;
  }

  characteristic->setValue(value.c_str());
  if (notify && g_server != nullptr && g_server->getConnectedCount() > 0) {
    characteristic->notify();
  }
}

void setWifiStatusInternal(const String &status, bool forceNotify = false) {
  const bool changed = g_wifiStatus != status;
  if (!changed && !forceNotify) {
    return;
  }
  g_wifiStatus = status;
  if (changed) {
    DEBUG_PRINTF("BLE wifi_status -> %s (uptime %lu ms)\n",
                  g_wifiStatus.c_str(), millis());
  }
  updateCharacteristic(g_wifiStatusChar, g_wifiStatus, true);
}

bool isFullyProvisioned() {
  String gw;
  String secret;
  String url;
  String inverterId;
  String expectedSn;
  if (!nvsGetGatewayId(gw)) return false;
  if (!nvsGetDeviceSecret(secret)) return false;
  if (!nvsGetSupabaseUrl(url)) return false;
  if (!nvsGetInverterId(inverterId)) return false;
  if (!nvsGetExpectedInverterSn(expectedSn)) return false;
  return gw.length() > 0 && secret.length() > 0 && url.length() > 0 &&
         inverterId.length() > 0 && expectedSn.length() > 0;
}

void setStatusInternal(const String &status) {
  const bool changed = g_status != status;
  if (changed) {
    DEBUG_PRINTF("BLE status -> %s (uptime %lu ms)\n", status.c_str(),
                 millis());
  }
  g_status = status;
  updateCharacteristic(g_statusChar, g_status, true);
}

void setHardwareIdInternal(const String &hardwareId) {
  g_hardwareId = trimCopy(hardwareId);
  updateCharacteristic(g_hardwareIdChar, g_hardwareId, false);
}

void setInverterSnInternal(const String &inverterSn) {
  g_inverterSn = normalizeSerialNumber(inverterSn);
  updateCharacteristic(g_inverterSnChar, g_inverterSn, true);
}

bool ensureNvs() { return nvsBegin(); }

bool parseWifiConfig(const String &payload, String *outError) {
  JsonDocument doc;
  DeserializationError error = deserializeJson(doc, payload);
  if (error) {
    if (outError != nullptr) {
      *outError = "invalid_json";
    }
    return false;
  }

  String ssid;
  if (!readStringField(doc, "ssid", ssid)) {
    if (outError != nullptr) {
      *outError = "missing_ssid";
    }
    return false;
  }

  String password;
  JsonVariantConst passwordValue = doc["password"];
  if (!passwordValue.isNull()) {
    const char *rawPassword = passwordValue.as<const char *>();
    if (rawPassword != nullptr) {
      password = rawPassword;
    }
  }

  if (!ensureNvs() || !nvsSetWifiCredentials(ssid, password)) {
    if (outError != nullptr) {
      *outError = "storage_failed";
    }
    return false;
  }

  if (outError != nullptr) {
    *outError = "";
  }
  return true;
}

bool parseCloudConfig(const String &payload, String *outError) {
  JsonDocument doc;
  DeserializationError error = deserializeJson(doc, payload);
  if (error) {
    if (outError != nullptr) {
      *outError = "invalid_json";
    }
    return false;
  }

  String supabaseUrl;
  if (!readStringField(doc, "supabase_url", supabaseUrl) &&
      !readStringField(doc, "url", supabaseUrl)) {
    if (outError != nullptr) {
      *outError = "missing_supabase_url";
    }
    return false;
  }

  if (!(supabaseUrl.startsWith("http://") ||
        supabaseUrl.startsWith("https://"))) {
    if (outError != nullptr) {
      *outError = "invalid_supabase_url";
    }
    return false;
  }

  if (!ensureNvs() || !nvsSetSupabaseUrl(supabaseUrl)) {
    if (outError != nullptr) {
      *outError = "storage_failed";
    }
    return false;
  }

  if (outError != nullptr) {
    *outError = "";
  }
  return true;
}

bool parseDeviceConfig(const String &payload, String *outError) {
  JsonDocument doc;
  DeserializationError error = deserializeJson(doc, payload);
  if (error) {
    if (outError != nullptr) {
      *outError = "invalid_json";
    }
    return false;
  }

  String gatewayId;
  String deviceSecret;
  String inverterId;
  String expectedSn;

  if (!readStringField(doc, "gateway_id", gatewayId) ||
      !readStringField(doc, "device_secret", deviceSecret) ||
      !readStringField(doc, "inverter_id", inverterId) ||
      (!readStringField(doc, "expected_inverter_sn", expectedSn) &&
       !readStringField(doc, "inverter_sn", expectedSn))) {
    if (outError != nullptr) {
      *outError = "missing_device_config_fields";
    }
    return false;
  }

  expectedSn = normalizeSerialNumber(expectedSn);

  if (!ensureNvs() || !nvsSetGatewayId(gatewayId) ||
      !nvsSetDeviceSecret(deviceSecret) || !nvsSetInverterId(inverterId) ||
      !nvsSetExpectedInverterSn(expectedSn)) {
    if (outError != nullptr) {
      *outError = "storage_failed";
    }
    return false;
  }

  if (outError != nullptr) {
    *outError = "";
  }
  return true;
}

void pollWifiConnectState() {
  if (g_wifiConnectPhase == WifiConnectPhase::Pending) {
    if (!ensureNvs()) {
      DEBUG_PRINTLN("BLE provision: NVS unavailable during WiFi connect");
      setStatusInternal("nvs_failed");
      setStatusLed(StatusLed::WIFI_FAILED);
      g_wifiConnectPhase = WifiConnectPhase::None;
      return;
    }

    String ssid;
    String password;
    if (!nvsGetWifiCredentials(ssid, password)) {
      setStatusInternal("wifi_missing");
      setStatusLed(StatusLed::WIFI_FAILED);
      g_wifiConnectPhase = WifiConnectPhase::None;
      DEBUG_PRINTLN("BLE provision: wifi credentials missing from NVS");
      return;
    }

    if (WiFi.status() == WL_CONNECTED) {
      setWifiStatusInternal("connected");
      setStatusInternal("wifi_connected");
      g_wifiConnectPhase = WifiConnectPhase::None;
      return;
    }

    setWifiStatusInternal("connecting");
    setStatusInternal("wifi_connecting");
    setStatusLed(StatusLed::WIFI_CONNECTING);
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid.c_str(), password.c_str());
    g_wifiConnectStartedMs = millis();
    g_wifiConnectPhase = WifiConnectPhase::InProgress;
    DEBUG_PRINTF("BLE provision: WiFi.begin ssid=%s\n", ssid.c_str());
    return;
  }

  if (g_wifiConnectPhase != WifiConnectPhase::InProgress) {
    return;
  }

  if (WiFi.status() == WL_CONNECTED) {
    setWifiStatusInternal("connected");
    setStatusInternal("wifi_connected");
    setStatusLed(StatusLed::PROVISIONING);
    g_wifiConnectPhase = WifiConnectPhase::None;
    DEBUG_PRINT("BLE provision WiFi OK, IP=");
    DEBUG_PRINTLN(WiFi.localIP());
    return;
  }

  if ((millis() - g_wifiConnectStartedMs) >= g_wifiConnectTimeoutMs) {
    WiFi.disconnect(true, true);
    setWifiStatusInternal("failed");
    setStatusInternal("wifi_failed");
    setStatusLed(StatusLed::WIFI_FAILED);
    g_wifiConnectPhase = WifiConnectPhase::None;
    DEBUG_PRINTLN("BLE provision: WiFi connect timeout");
  }
}

class ProvisionServerCallbacks : public NimBLEServerCallbacks {
public:
  void onConnect(NimBLEServer *server, NimBLEConnInfo &connInfo) override {
    (void)server;
    DEBUG_PRINTF("BLE provision: client connected (conn=%u)\n",
                 connInfo.getConnHandle());
    // Always push the canonical pre-provision state. Mobile BLE stacks cache
    // GATT values per device address and may replay "failed" from a prior
    // session even after the ESP32 has rebooted with wifi_status = idle.
    setWifiStatusInternal("idle", true);
  }

  void onDisconnect(NimBLEServer *server, NimBLEConnInfo &connInfo,
                    int reason) override {
    (void)server;
    (void)connInfo;
    DEBUG_PRINTF("BLE provision: client disconnected (reason=%d)\n", reason);
    NimBLEDevice::startAdvertising();
  }
};

class ProvisionWriteCallback : public NimBLECharacteristicCallbacks {
public:
  enum class Kind {
    Wifi,
    Cloud,
    Device,
  };

  explicit ProvisionWriteCallback(Kind kind) : kind_(kind) {}

  void onWrite(NimBLECharacteristic *characteristic,
               NimBLEConnInfo &connInfo) override {
    (void)connInfo;
    String payload = characteristic->getValue().c_str();
    String error;
    bool ok = false;

    switch (kind_) {
    case Kind::Wifi:
      g_pendingWifiConfigPayload = payload;
      g_hasPendingWifiConfig = true;
      DEBUG_PRINTF("BLE provision: wifi config write received (%u bytes)\n",
                    static_cast<unsigned>(payload.length()));
      break;

    case Kind::Cloud:
      DEBUG_PRINTF("BLE provision: cloud config write received (%u bytes)\n",
                   static_cast<unsigned>(payload.length()));
      ok = parseCloudConfig(payload, &error);
      if (ok) {
        setStatusInternal("cloud_configured");
        DEBUG_PRINTLN("BLE provision: cloud config stored");
      } else {
        const String err = error.length() > 0 ? error : String("cloud_error");
        setStatusInternal(err);
        DEBUG_PRINTF("BLE provision: cloud config rejected: %s\n", err.c_str());
      }
      break;

    case Kind::Device:
      DEBUG_PRINTF("BLE provision: device config write received (%u bytes)\n",
                   static_cast<unsigned>(payload.length()));
      ok = parseDeviceConfig(payload, &error);
      if (ok) {
        setStatusInternal("device_configured");
        DEBUG_PRINTLN("BLE provision: device config stored");
        setStatusLed(StatusLed::PROVISIONED);
        if (isFullyProvisioned()) {
          DEBUG_PRINTLN("BLE provision: all credentials present — fully provisioned");
        } else {
          DEBUG_PRINTLN("BLE provision: device config stored but provisioning incomplete");
        }
      } else {
        const String err = error.length() > 0 ? error : String("device_error");
        setStatusInternal(err);
        DEBUG_PRINTF("BLE provision: device config rejected: %s\n",
                     err.c_str());
        setStatusLed(StatusLed::PROVISION_FAILED);
      }
      break;
    }
  }

private:
  Kind kind_;
};

} // namespace

void bleProvisionBegin() {
  if (g_started) {
    return;
  }

  if (!ensureNvs()) {
    DEBUG_PRINTLN("BLE provision: NVS init failed");
    return;
  }

  setHardwareIdInternal(efuseMacAsString());
  if (g_inverterSn.length() == 0) {
    setInverterSnInternal("unknown");
  }

  NimBLEDevice::init("GroBase-Setup");
  NimBLEDevice::setPower(ESP_PWR_LVL_P9);

  g_server = NimBLEDevice::createServer();
  g_server->setCallbacks(new ProvisionServerCallbacks());
  NimBLEService *service = g_server->createService(kServiceUuid);

  g_hardwareIdChar =
      service->createCharacteristic(kHardwareIdUuid, NIMBLE_PROPERTY::READ);
  g_hardwareIdChar->setValue(g_hardwareId.c_str());

  g_inverterSnChar = service->createCharacteristic(
      kInverterSnUuid, NIMBLE_PROPERTY::READ | NIMBLE_PROPERTY::NOTIFY);
  g_inverterSnChar->setValue(g_inverterSn.c_str());

  g_wifiConfigChar =
      service->createCharacteristic(kWifiConfigUuid, NIMBLE_PROPERTY::WRITE);
  g_wifiConfigChar->setCallbacks(
      new ProvisionWriteCallback(ProvisionWriteCallback::Kind::Wifi));

  g_cloudConfigChar =
      service->createCharacteristic(kCloudConfigUuid, NIMBLE_PROPERTY::WRITE);
  g_cloudConfigChar->setCallbacks(
      new ProvisionWriteCallback(ProvisionWriteCallback::Kind::Cloud));

  g_deviceConfigChar =
      service->createCharacteristic(kDeviceConfigUuid, NIMBLE_PROPERTY::WRITE);
  g_deviceConfigChar->setCallbacks(
      new ProvisionWriteCallback(ProvisionWriteCallback::Kind::Device));

  g_wifiStatusChar = service->createCharacteristic(
      kWifiStatusUuid, NIMBLE_PROPERTY::READ | NIMBLE_PROPERTY::NOTIFY);
  g_wifiStatusChar->setValue(g_wifiStatus.c_str());

  g_statusChar = service->createCharacteristic(
      kStatusUuid, NIMBLE_PROPERTY::READ | NIMBLE_PROPERTY::NOTIFY);
  g_statusChar->setValue(g_status.c_str());

  service->start();

  NimBLEAdvertising *advertising = NimBLEDevice::getAdvertising();
  advertising->addServiceUUID(kServiceUuid);
  advertising->enableScanResponse(true);
  advertising->start();

  g_started = true;
  setStatusInternal("advertising");
  DEBUG_PRINTF("BLE provision: started, hardware_id=%s inverter_sn=%s\n",
               g_hardwareId.c_str(), g_inverterSn.c_str());
}

void bleProvisionStop() {
  if (!g_started) {
    return;
  }

  NimBLEDevice::stopAdvertising();
  NimBLEDevice::deinit(true);

  g_server = nullptr;
  g_hardwareIdChar = nullptr;
  g_inverterSnChar = nullptr;
  g_wifiConfigChar = nullptr;
  g_cloudConfigChar = nullptr;
  g_deviceConfigChar = nullptr;
  g_wifiStatusChar = nullptr;
  g_statusChar = nullptr;
  g_wifiConnectPhase = WifiConnectPhase::None;
  g_hasPendingWifiConfig = false;
  g_pendingWifiConfigPayload = "";
  g_wifiStatus = "idle";
  g_status = "idle";
  g_started = false;

  DEBUG_PRINTLN("BLE provision: stopped");
}

bool bleProvisionIsActive() { return g_started; }

void bleProvisionPoll() {
  if (!g_started) {
    return;
  }

  if (g_hasPendingWifiConfig) {
    g_hasPendingWifiConfig = false;
    const String payload = g_pendingWifiConfigPayload;
    g_pendingWifiConfigPayload = "";
    String error;
    const bool ok = parseWifiConfig(payload, &error);
    if (ok) {
      setStatusInternal("wifi_configured");
      g_wifiConnectPhase = WifiConnectPhase::Pending;
      g_wifiConnectTimeoutMs = 30000;
      DEBUG_PRINTLN("BLE provision: wifi config stored, connect scheduled");
    } else {
      const String err = error.length() > 0 ? error : String("wifi_error");
      setStatusInternal(err);
      DEBUG_PRINTF("BLE provision: wifi config rejected: %s\n", err.c_str());
    }
  }

  pollWifiConnectState();

  delay(1);
}

void bleProvisionSetHardwareId(const String &hardwareId) {
  setHardwareIdInternal(hardwareId);
}

void bleProvisionSetInverterSn(const String &inverterSn) {
  setInverterSnInternal(inverterSn);
}

void bleProvisionSetWifiStatus(const String &status) {
  setWifiStatusInternal(trimCopy(status));
}

void bleProvisionSetStatus(const String &status) {
  setStatusInternal(trimCopy(status));
}

bool bleProvisionApplyWifiConfigJson(const String &payload, String *outError) {
  return parseWifiConfig(payload, outError);
}

bool bleProvisionApplyCloudConfigJson(const String &payload, String *outError) {
  return parseCloudConfig(payload, outError);
}

bool bleProvisionApplyDeviceConfigJson(const String &payload,
                                       String *outError) {
  return parseDeviceConfig(payload, outError);
}

bool bleProvisionConnectWifiFromNvs(uint32_t timeoutMs) {
  g_wifiConnectTimeoutMs = timeoutMs;
  g_wifiConnectPhase = WifiConnectPhase::Pending;

  const uint32_t deadline = millis() + timeoutMs + 5000;
  while (g_wifiConnectPhase != WifiConnectPhase::None && millis() < deadline) {
    pollWifiConnectState();
    delay(10);
  }

  return g_wifiStatus == "connected";
}
