#// Main firmware entrypoint: Modbus polling, snapshot creation,
#// and periodic upload to Supabase. Uses `inverter_snapshot` and
#// `supabase_client` modules.
#include <Arduino.h>
#include "ble_provision.h"
#include "inverter_snapshot.h"
#include "supabase_client.h"
#include "wifi_manager.h"
#include "nvs_storage.h"

// -----------------------------
// User config (application-level)
// -----------------------------
static const uint32_t DEBUG_BAUD = 115200;
static const uint32_t UPLOAD_INTERVAL_MS = 5UL * 60UL * 1000UL;  // 5 minutes
static const uint32_t PROVISION_CHECK_INTERVAL_MS = 2000UL;
static const uint32_t WIFI_RETRY_INTERVAL_MS = 10000UL;
static const uint32_t MODBUS_BACKOFF_MS = 30UL * 60UL * 1000UL; // 30 minutes
static const uint8_t SN_READ_ATTEMPTS = 3;
static const uint32_t SN_READ_RETRY_DELAY_MS = 250;

#include "modbus.h"
#include "status_led.h"

// Forward declarations used by setup
static String g_cachedSn;
static bool g_snReadOk = false;
static uint32_t g_lastModbusFailMs = 0;
static bool readAndCacheSerialNumber();
static void setBootStatus();
static void setSetupStatus();
static void setWifiConnectingStatus();
static void setHealthyStatus();
static void setWifiUnreachableFault();
static void setCloudUnreachableFault();
static void setSnReadFailedFault();
static void setSnMismatchFault();

void setup() {
  Serial.begin(DEBUG_BAUD);
  delay(1000);

  modbusInit();
  bleProvisionBegin();
#ifdef LED_BUILTIN
  status_led_init(LED_BUILTIN);
#else
  status_led_init(2);
#endif
  // Show BOOT status briefly
  setBootStatus();
  Serial.println("Growatt SPA3000TL gateway — Modbus + Supabase (state machine)");

  // NVS init early so modules can read provisioning state.
  if (!nvsBegin()) {
    Serial.println("NVS init failed");
  }
  // Read SN once at boot for BLE display and later SN_CHECK
  if (!readAndCacheSerialNumber()) {
    Serial.println("Warning: SN read failed at boot");
    bleProvisionSetInverterSn("");
  } else {
    Serial.printf("Cached SN=%s\n", g_cachedSn.c_str());
  }
}

// State machine for firmware lifecycle per PLAN.md
enum class SystemState {
  Startup,
  Provisioning,
  WifiConnecting,
  Ready,
  Running,
  FaultSn,
  Error,
};

static SystemState g_state = SystemState::Startup;


// Read serial number (holding regs 23..27) and cache it.
static bool readAndCacheSerialNumber() {
  uint16_t regs[5];
  for (uint8_t attempt = 0; attempt < SN_READ_ATTEMPTS; ++attempt) {
    // slave id 1, start 23, count 5
    if (readRegisters03(1, 23, 5, regs)) {
      // Each register contains two ASCII chars: high byte first, then low byte
      char buf[11];
      int pos = 0;
      for (int i = 0; i < 5; ++i) {
        uint16_t v = regs[i];
        char hi = (char)((v >> 8) & 0xFF);
        char lo = (char)(v & 0xFF);
        buf[pos++] = hi;
        buf[pos++] = lo;
      }
      buf[pos] = '\0';

      String s = String(buf);
      s.trim();
      s.toUpperCase();
      g_cachedSn = s;
      g_snReadOk = (g_cachedSn.length() > 0);

      // Expose to BLE provision characteristic
      bleProvisionSetInverterSn(g_cachedSn);
      return g_snReadOk;
    }

    if (attempt + 1 < SN_READ_ATTEMPTS) {
      delay(SN_READ_RETRY_DELAY_MS);
    }
  }

  g_snReadOk = false;
  g_cachedSn = "";
  return false;
}

static bool isProvisioned() {
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
  return gw.length() > 0 && secret.length() > 0 && url.length() > 0 && inverterId.length() > 0 && expectedSn.length() > 0;
}

static void setBootStatus() {
  status_led_set_status(4);
}

static void setSetupStatus() {
  status_led_clear();
  status_led_set_status(2);
}

static void setWifiConnectingStatus() {
  status_led_clear();
  status_led_set_status(3);
}

static void setHealthyStatus() {
  status_led_clear();
}

static void setWifiUnreachableFault() {
  status_led_set_status(0);
  status_led_set_fault(3);
}

static void setCloudUnreachableFault() {
  status_led_set_status(0);
  status_led_set_fault(5);
}

static void setSnReadFailedFault() {
  status_led_set_status(0);
  status_led_set_fault(2);
}

static void setSnMismatchFault() {
  status_led_set_status(0);
  status_led_set_fault(4);
}

void processProvisioning() {
  // BLE handles writes and may attempt WiFi connect itself; poll BLE continuously.
  bleProvisionPoll();
  // Provisioning -> BLE setup long blink (2)
  setSetupStatus();
}

void processWifiConnect() {
  // Attempt to connect using wifi_manager which reads NVS credentials.
  // Indicate WiFi connecting
  setWifiConnectingStatus();
  if (wifiManagerEnsureConnected()) {
    Serial.println("WiFi connected via wifi_manager");
    if (supabaseBegin()) {
      setHealthyStatus();
      g_state = SystemState::Ready;
      return;
    } else {
      Serial.println("supabaseBegin failed; will retry");
      // Cloud unreachable fault
      setCloudUnreachableFault();
      g_state = SystemState::Error;
      return;
    }
  }
  setWifiUnreachableFault();
  // Stay in WifiConnecting and retry after delay handled by loop timing.
}

void processRunning() {
  // Primary work: poll Modbus and upload snapshots on interval.
  static uint32_t lastUpload = 0;
  bleProvisionPoll();

  // Respect modbus backoff window after failures
  if (g_lastModbusFailMs != 0 && (millis() - g_lastModbusFailMs) < MODBUS_BACKOFF_MS) {
    // still in backoff
    return;
  }

  if (millis() - lastUpload < UPLOAD_INTERVAL_MS) return;
  lastUpload = millis();

  static uint16_t r1009[51];
  static uint16_t r1086[3];
  static uint16_t r1124[27];
  static uint16_t r2035[20];
  static uint16_t r2097[1];
  static uint16_t r2112[6];

  InverterSnapshot snapshot = {};
  if (!readAppRegisters(r1009, r1086, r1124, r2035, r2097, r2112)) {
    Serial.println("Modbus read failed; posting event and entering backoff");
    String invId;
    if (!nvsGetInverterId(invId)) invId = "";
    // Post event; don't block on failure — v1 drops events if cannot upload
    supabaseInsertEvent(invId, "modbus_failed", "warn", "scheduled modbus poll failed", "{}");
    setCloudUnreachableFault();
    g_lastModbusFailMs = millis();
    return;
  }
  // success, clear any previous failure state
  g_lastModbusFailMs = 0; 

  fillInverterSnapshot(&snapshot, r1009, r1086, r1124, r2035, r2097, r2112);
  printInverterSnapshotJson(&snapshot);

  if (!supabaseInsertSnapshot(&snapshot)) {
    Serial.println("{\"error\":\"supabase_upload_failed\"}");
  }


}

void loop() {
  // Drive LED state machine every loop
  status_led_poll();
  static uint32_t lastProvisionCheck = 0;
  static uint32_t lastWifiRetry = 0;

  switch (g_state) {
    case SystemState::Startup: {
      // Boot: first, ensure SN read succeeded. If SN read failed, halt until reboot.
      if (!g_snReadOk) {
        Serial.println("Boot SN read failed; entering FaultSn state (no further actions until reboot)");
        // Expose empty SN to BLE and set status for app
        bleProvisionSetInverterSn("");
        bleProvisionSetStatus("sn_unavailable");
        // If device was previously provisioned, post an event to backend
        if (isProvisioned()) {
          String invId;
          if (!nvsGetInverterId(invId)) invId = "";
          supabaseInsertEvent(invId, "sn_read_failed", "error", "boot SN read failed", "{}");
        }
        setSnReadFailedFault();
        g_state = SystemState::FaultSn;
      } else if (isProvisioned()) {
        Serial.println("Device is provisioned; performing boot SN check");
        // Compare to expected_inverter_sn from NVS
        String expected;
        if (nvsGetExpectedInverterSn(expected)) {
          expected.toUpperCase();
          if (expected.length() > 0 && expected != g_cachedSn) {
            Serial.printf("SN mismatch: cached=%s expected=%s\n", g_cachedSn.c_str(), expected.c_str());
            String invId;
            if (!nvsGetInverterId(invId)) invId = "";
            supabaseInsertEvent(invId, "sn_mismatch", "error", "boot serial mismatch", "{}");
            setSnMismatchFault();
            g_state = SystemState::FaultSn;
          } else {
            Serial.println("Boot SN OK; attempting WiFi");
            g_state = SystemState::WifiConnecting;
          }
        } else {
          // No expected SN in NVS; proceed to WiFi (defensive)
          Serial.println("No expected SN found in NVS; attempting WiFi");
          g_state = SystemState::WifiConnecting;
        }
      } else {
        Serial.println("Device not provisioned; entering provisioning mode");
        g_state = SystemState::Provisioning;
      }
      break;
    }

    case SystemState::Provisioning: {
      processProvisioning();
      if (millis() - lastProvisionCheck > PROVISION_CHECK_INTERVAL_MS) {
        lastProvisionCheck = millis();
        if (isProvisioned()) {
          Serial.println("Provisioning complete; moving to WiFi connect");
          g_state = SystemState::WifiConnecting;
        }
      }
      break;
    }

    case SystemState::WifiConnecting: {
      // Avoid tight retry loops
      if (millis() - lastWifiRetry < WIFI_RETRY_INTERVAL_MS) {
        setWifiConnectingStatus();
        bleProvisionPoll();
        delay(50);
        break;
      }
      lastWifiRetry = millis();
      processWifiConnect();
      break;
    }

    case SystemState::Ready: {
      // Ready → start running main loop
      Serial.println("System ready; entering running state");
      g_state = SystemState::Running;
      break;
    }

    case SystemState::Running: {
      if (!wifiManagerIsConnected()) {
        setWifiUnreachableFault();
      } else {
        setHealthyStatus();
      }
      processRunning();
      break;
    }

    case SystemState::FaultSn: {
      // Fault due to SN mismatch or SN read failure — idle until reboot.
      // BLE remains available for recovery/inspection.
      bleProvisionPoll();
      // SN mismatch fault code (4 short) or SN read failed (2 short) already set where detected
      delay(500);
      break;
    }

    case SystemState::Error: {
      // On error, try to recover by attempting WiFi again after a pause.
      if (millis() - lastWifiRetry > WIFI_RETRY_INTERVAL_MS) {
        Serial.println("Recovering from error: retrying WiFi");
        g_state = SystemState::WifiConnecting;
        lastWifiRetry = millis();
      }
      bleProvisionPoll();
      delay(100);
      break;
    }
  }
}