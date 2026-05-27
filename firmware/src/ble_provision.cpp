#include "ble_provision.h"

#include "nvs_storage.h"
#include "status_led.h"

#include <ArduinoJson.h>
#include <NimBLEDevice.h>
#include <WiFi.h>

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
  snprintf(out,
           sizeof(out),
           "%02X:%02X:%02X:%02X:%02X:%02X",
           (uint8_t)((mac >> 40) & 0xFF),
           (uint8_t)((mac >> 32) & 0xFF),
           (uint8_t)((mac >> 24) & 0xFF),
           (uint8_t)((mac >> 16) & 0xFF),
           (uint8_t)((mac >> 8) & 0xFF),
           (uint8_t)(mac & 0xFF));
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

void updateCharacteristic(NimBLECharacteristic *characteristic, const String &value, bool notify) {
  if (characteristic == nullptr) {
    return;
  }

  characteristic->setValue(value.c_str());
  if (notify && g_server != nullptr && g_server->getConnectedCount() > 0) {
    characteristic->notify();
  }
}

void setWifiStatusInternal(const String &status) {
  g_wifiStatus = status;
  updateCharacteristic(g_wifiStatusChar, g_wifiStatus, true);
}

void setStatusInternal(const String &status) {
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

bool ensureNvs() {
  return nvsBegin();
}

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
  if (!readStringField(doc, "supabase_url", supabaseUrl) && !readStringField(doc, "url", supabaseUrl)) {
    if (outError != nullptr) {
      *outError = "missing_supabase_url";
    }
    return false;
  }

  if (!(supabaseUrl.startsWith("http://") || supabaseUrl.startsWith("https://"))) {
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

  // Optional: accept anon key from the app and persist to NVS
  String anonKey;
  if (readStringField(doc, "anon_key", anonKey) || readStringField(doc, "supabase_anon", anonKey) || readStringField(doc, "apikey", anonKey)) {
    nvsSetSupabaseAnonKey(anonKey);
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
      (!readStringField(doc, "expected_inverter_sn", expectedSn) && !readStringField(doc, "inverter_sn", expectedSn))) {
    if (outError != nullptr) {
      *outError = "missing_device_config_fields";
    }
    return false;
  }

  expectedSn = normalizeSerialNumber(expectedSn);

  if (!ensureNvs() ||
      !nvsSetGatewayId(gatewayId) ||
      !nvsSetDeviceSecret(deviceSecret) ||
      !nvsSetInverterId(inverterId) ||
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

class ProvisionWriteCallback : public NimBLECharacteristicCallbacks {
 public:
  enum class Kind {
    Wifi,
    Cloud,
    Device,
  };

  explicit ProvisionWriteCallback(Kind kind) : kind_(kind) {}

  void onWrite(NimBLECharacteristic *characteristic, NimBLEConnInfo &connInfo) override {
    (void)connInfo;
    String payload = characteristic->getValue().c_str();
    String error;
    bool ok = false;

    switch (kind_) {
      case Kind::Wifi:
        ok = parseWifiConfig(payload, &error);
        if (ok) {
          setStatusInternal("wifi_configured");
          bleProvisionConnectWifiFromNvs();
        } else {
          setWifiStatusInternal("failed");
          setStatusInternal(error.length() > 0 ? error : String("wifi_error"));
        }
        break;

      case Kind::Cloud:
        ok = parseCloudConfig(payload, &error);
        if (ok) {
          setStatusInternal("cloud_configured");
        } else {
          setStatusInternal(error.length() > 0 ? error : String("cloud_error"));
        }
        break;

      case Kind::Device:
        ok = parseDeviceConfig(payload, &error);
        if (ok) {
          setStatusInternal("device_configured");
        } else {
          setStatusInternal(error.length() > 0 ? error : String("device_error"));
        }
        break;
    }
  }

 private:
  Kind kind_;
};

}  // namespace

void bleProvisionBegin() {
  if (g_started) {
    return;
  }

  if (!ensureNvs()) {
    Serial.println("BLE provision: NVS init failed");
    return;
  }

  setHardwareIdInternal(efuseMacAsString());
  if (g_inverterSn.length() == 0) {
    setInverterSnInternal("unknown");
  }

  NimBLEDevice::init("GroBase-Setup");
  NimBLEDevice::setPower(ESP_PWR_LVL_P9);

  g_server = NimBLEDevice::createServer();
  NimBLEService *service = g_server->createService(kServiceUuid);

  g_hardwareIdChar = service->createCharacteristic(kHardwareIdUuid, NIMBLE_PROPERTY::READ);
  g_hardwareIdChar->setValue(g_hardwareId.c_str());

  g_inverterSnChar = service->createCharacteristic(kInverterSnUuid, NIMBLE_PROPERTY::READ | NIMBLE_PROPERTY::NOTIFY);
  g_inverterSnChar->setValue(g_inverterSn.c_str());

  g_wifiConfigChar = service->createCharacteristic(kWifiConfigUuid, NIMBLE_PROPERTY::WRITE);
  g_wifiConfigChar->setCallbacks(new ProvisionWriteCallback(ProvisionWriteCallback::Kind::Wifi));

  g_cloudConfigChar = service->createCharacteristic(kCloudConfigUuid, NIMBLE_PROPERTY::WRITE);
  g_cloudConfigChar->setCallbacks(new ProvisionWriteCallback(ProvisionWriteCallback::Kind::Cloud));

  g_deviceConfigChar = service->createCharacteristic(kDeviceConfigUuid, NIMBLE_PROPERTY::WRITE);
  g_deviceConfigChar->setCallbacks(new ProvisionWriteCallback(ProvisionWriteCallback::Kind::Device));

  g_wifiStatusChar = service->createCharacteristic(kWifiStatusUuid, NIMBLE_PROPERTY::READ | NIMBLE_PROPERTY::NOTIFY);
  g_wifiStatusChar->setValue(g_wifiStatus.c_str());

  g_statusChar = service->createCharacteristic(kStatusUuid, NIMBLE_PROPERTY::READ | NIMBLE_PROPERTY::NOTIFY);
  g_statusChar->setValue(g_status.c_str());

  service->start();

  NimBLEAdvertising *advertising = NimBLEDevice::getAdvertising();
  advertising->addServiceUUID(kServiceUuid);
  advertising->enableScanResponse(true);
  advertising->start();

  g_started = true;
  setStatusInternal("advertising");
}

void bleProvisionPoll() {
  if (!g_started) {
    return;
  }

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

bool bleProvisionApplyDeviceConfigJson(const String &payload, String *outError) {
  return parseDeviceConfig(payload, outError);
}

bool bleProvisionConnectWifiFromNvs(uint32_t timeoutMs) {
  if (!ensureNvs()) {
    setWifiStatusInternal("failed");
    setStatusInternal("nvs_failed");
    status_led_set_fault(3);
    return false;
  }

  String ssid;
  String password;
  if (!nvsGetWifiCredentials(ssid, password)) {
    setWifiStatusInternal("failed");
    setStatusInternal("wifi_missing");
    status_led_set_fault(3);
    return false;
  }

  if (WiFi.status() == WL_CONNECTED) {
    setWifiStatusInternal("connected");
    setStatusInternal("wifi_connected");
    return true;
  }

  setWifiStatusInternal("connecting");
  setStatusInternal("wifi_connecting");
  status_led_set_status(3);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid.c_str(), password.c_str());

  uint32_t startedAt = millis();
  while (WiFi.status() != WL_CONNECTED && (millis() - startedAt) < timeoutMs) {
    delay(250);
  }

  if (WiFi.status() != WL_CONNECTED) {
    WiFi.disconnect(true, true);
    setWifiStatusInternal("failed");
    setStatusInternal("wifi_failed");
    status_led_set_fault(3);
    return false;
  }

  setWifiStatusInternal("connected");
  setStatusInternal("wifi_connected");
  status_led_clear();
  Serial.print("BLE provision WiFi OK, IP=");
  Serial.println(WiFi.localIP());
  return true;
}
