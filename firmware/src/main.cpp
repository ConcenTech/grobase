#// Main firmware entrypoint: Modbus polling, snapshot creation,
#// and periodic upload to Supabase. Uses `inverter_snapshot` and
#// `supabase_client` modules.
#include <Arduino.h>
#include "ble_provision.h"
#include "debug_print.h"
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


static void logProvisioningFields(const char *context);

void setup() {
  Serial.begin(DEBUG_BAUD);

  initStatusLed();
  
  setStatusLed(StatusLed::BOOT);

  delay(1000);

  modbusInit();

  DEBUG_PRINTLN("Growatt SPA3000TL gateway — Modbus + Supabase (state machine)");

  // NVS init early so modules can read provisioning state.
  if (!nvsBegin()) {
    DEBUG_PRINTLN("NVS init failed");
  } else {
    logProvisioningFields("boot");
  }
  // Read SN once at boot for BLE display and later SN_CHECK
  if (!readAndCacheSerialNumber()) {
    DEBUG_PRINTLN("Warning: SN read failed at boot");
    bleProvisionSetInverterSn("");
  } else {
    DEBUG_PRINTF("Cached SN=%s\n", g_cachedSn.c_str());
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

static void logProvisioningFields(const char *context) {
  String gw;
  String secret;
  String url;
  String inverterId;
  String expectedSn;
  String ssid;
  String password;
  DEBUG_PRINTF(
      "Provision fields (%s): gateway=%s secret=%s url=%s inverter=%s "
      "expected_sn=%s wifi=%s\n",
      context, nvsGetGatewayId(gw) ? "yes" : "no",
      nvsGetDeviceSecret(secret) ? "yes" : "no",
      nvsGetSupabaseUrl(url) ? "yes" : "no",
      nvsGetInverterId(inverterId) ? "yes" : "no",
      nvsGetExpectedInverterSn(expectedSn) ? "yes" : "no",
      nvsGetWifiCredentials(ssid, password) ? "yes" : "no");
}

static const char *systemStateName(SystemState state) {
  switch (state) {
  case SystemState::Startup:
    return "Startup";
  case SystemState::Provisioning:
    return "Provisioning";
  case SystemState::WifiConnecting:
    return "WifiConnecting";
  case SystemState::Ready:
    return "Ready";
  case SystemState::Running:
    return "Running";
  case SystemState::FaultSn:
    return "FaultSn";
  case SystemState::Error:
    return "Error";
  }
  return "Unknown";
}

static void setSystemState(SystemState nextState) {
  if (g_state == nextState) {
    return;
  }

  if (g_state == SystemState::Provisioning) {
    bleProvisionStop();
  }

  DEBUG_PRINTF("System state: %s -> %s\n", systemStateName(g_state),
               systemStateName(nextState));
  g_state = nextState;

  if (nextState == SystemState::Provisioning) {
    bleProvisionBegin();
  }
}

void processProvisioning() {
  // BLE handles writes and may attempt WiFi connect itself; poll BLE continuously.
  bleProvisionPoll();
}

void processWifiConnect() {
  // Attempt to connect using wifi_manager which reads NVS credentials.
  // Indicate WiFi connecting
  setStatusLed(StatusLed::WIFI_CONNECTING);
  if (wifiManagerEnsureConnected()) {
    DEBUG_PRINTLN("WiFi connected via wifi_manager");
    if (supabaseBegin()) {
      setStatusLed(StatusLed::PROVISIONED);
      setSystemState(SystemState::Ready);
      return;
    } else {
      DEBUG_PRINTLN("supabaseBegin failed; will retry");
      // Cloud unreachable fault
      setStatusLed(StatusLed::CLOUD_UNREACHABLE);
      setSystemState(SystemState::Error);
      return;
    }
  }
  DEBUG_PRINTLN("WiFi connect failed; staying in WifiConnecting for retry");
  setStatusLed(StatusLed::WIFI_FAILED);
  // Stay in WifiConnecting and retry after delay handled by loop timing.
}

void processRunning() {
  // Primary work: poll Modbus and upload snapshots on interval.
  static uint32_t lastUpload = 0;

  // Respect modbus backoff window after failures
  if (g_lastModbusFailMs != 0 && (millis() - g_lastModbusFailMs) < MODBUS_BACKOFF_MS) {
    // still in backoff
    return;
  }

  // lastUpload == 0 means no upload yet — run immediately on first entry to Running.
  if (lastUpload != 0 && (millis() - lastUpload) < UPLOAD_INTERVAL_MS) return;
  lastUpload = millis();

  static uint16_t r1009[51];
  static uint16_t r1086[3];
  static uint16_t r1124[27];
  static uint16_t r2035[20];
  static uint16_t r2097[1];
  static uint16_t r2112[6];

  InverterSnapshot snapshot = {};
  if (!readAppRegisters(r1009, r1086, r1124, r2035, r2097, r2112)) {
    DEBUG_PRINTLN("Modbus read failed; posting event and entering backoff");
    String invId;
    if (!nvsGetInverterId(invId)) invId = "";
    // Post event; don't block on failure — v1 drops events if cannot upload
    supabaseInsertEvent(invId, "modbus_failed", "warn", "scheduled modbus poll failed", "{}");
    setStatusLed(StatusLed::MODBUS_FAILED);
    g_lastModbusFailMs = millis();
    return;
  }
  // success, clear any previous failure state
  g_lastModbusFailMs = 0; 

  fillInverterSnapshot(&snapshot, r1009, r1086, r1124, r2035, r2097, r2112);
  printInverterSnapshotJson(&snapshot);

#if MODBUS_DEBUG
  {
    String dump;
    if (readModbusDebugDumpJson(dump)) {
      snapshot.modbus_debug_metadata = dump;
      DEBUG_PRINTLN("Modbus debug dump captured for metadata");
    } else {
      DEBUG_PRINTLN("Modbus debug dump failed (continuing without metadata)");
    }
  }
#endif

  if (!supabaseInsertSnapshot(&snapshot)) {
    DEBUG_PRINTLN("{\"error\":\"supabase_upload_failed\"}");
    setStatusLed(StatusLed::CLOUD_UNREACHABLE);
    return;
  }

  if (wifiManagerIsConnected()) {
    setStatusLed(StatusLed::PROVISIONED);
  }
}

void loop() {
  static uint32_t lastProvisionCheck = 0;
  static uint32_t lastWifiRetry = 0;

  switch (g_state) {
    case SystemState::Startup: {
      // Boot: first, ensure SN read succeeded. If SN read failed, halt until reboot.
      if (!g_snReadOk) {
        DEBUG_PRINTLN("Boot SN read failed; entering FaultSn state (no further actions until reboot)");
        // If device was previously provisioned, post an event to backend
        if (isProvisioned()) {
          String invId;
          if (!nvsGetInverterId(invId)) invId = "";
          supabaseInsertEvent(invId, "sn_read_failed", "error", "boot SN read failed", "{}");
        }
        setStatusLed(StatusLed::SN_READ_FAILED);
        setSystemState(SystemState::FaultSn);
      } else if (isProvisioned()) {
        DEBUG_PRINTLN("Device is provisioned; performing boot SN check");
        // Compare to expected_inverter_sn from NVS
        String expected;
        if (nvsGetExpectedInverterSn(expected)) {
          expected.toUpperCase();
          if (expected.length() > 0 && expected != g_cachedSn) {
            DEBUG_PRINTF("SN mismatch: cached=%s expected=%s\n", g_cachedSn.c_str(), expected.c_str());
            String invId;
            if (!nvsGetInverterId(invId)) invId = "";
            supabaseInsertEvent(invId, "sn_mismatch", "error", "boot serial mismatch", "{}");
            setStatusLed(StatusLed::SN_MISMATCH);
            setSystemState(SystemState::FaultSn);
          } else {
            DEBUG_PRINTLN("Boot SN OK; attempting WiFi");
            setSystemState(SystemState::WifiConnecting);
          }
        } else {
          // No expected SN in NVS; proceed to WiFi (defensive)
          DEBUG_PRINTLN("No expected SN found in NVS; attempting WiFi");
          setSystemState(SystemState::WifiConnecting);
        }
      } else {
        DEBUG_PRINTLN("Device not provisioned; entering provisioning mode");
        setStatusLed(StatusLed::SETUP);
        setSystemState(SystemState::Provisioning);
      }
      break;
    }

    case SystemState::Provisioning: {
      processProvisioning();
      if (millis() - lastProvisionCheck > PROVISION_CHECK_INTERVAL_MS) {
        lastProvisionCheck = millis();
        if (isProvisioned()) {
          DEBUG_PRINTLN("Provisioning complete; moving to WiFi connect");
          logProvisioningFields("provisioned");
          setSystemState(SystemState::WifiConnecting);
        }
      }
      break;
    }

    case SystemState::WifiConnecting: {
      // Avoid tight retry loops
      if (millis() - lastWifiRetry < WIFI_RETRY_INTERVAL_MS) {
        setStatusLed(StatusLed::WIFI_CONNECTING);
        delay(50);
        break;
      }
      lastWifiRetry = millis();
      processWifiConnect();
      break;
    }

    case SystemState::Ready: {
      // Ready → start running main loop
      DEBUG_PRINTLN("System ready; entering running state");
      setSystemState(SystemState::Running);
      break;
    }

    case SystemState::Running: {
      if (!wifiManagerIsConnected()) {
        setStatusLed(StatusLed::WIFI_FAILED);
      }
      processRunning();
      break;
    }

    case SystemState::FaultSn: {
      // Fault due to SN mismatch or SN read failure — idle until reboot.
      static bool faultLogged = false;
      if (!faultLogged) {
        DEBUG_PRINTLN("FaultSn: serial number fault — idle until reboot");
        faultLogged = true;
      }
      delay(500);
      break;
    }

    case SystemState::Error: {
      // On error, try to recover by attempting WiFi again after a pause.
      if (millis() - lastWifiRetry > WIFI_RETRY_INTERVAL_MS) {
        DEBUG_PRINTLN("Recovering from error: retrying WiFi");
        setSystemState(SystemState::WifiConnecting);
        lastWifiRetry = millis();
      }
      delay(100);
      break;
    }
  }
}