# LED Fault & Status Codes

This document lists the onboard LED status and fault patterns used by the firmware.

The LED runs on a dedicated FreeRTOS task. Each pattern repeats until the firmware
sets a new `StatusLed` value. **A new state takes effect only after the current blink
sequence finishes**, so users can count blinks reliably.

Timing:

- **Long blinks (status):** 500 ms on, 500 ms off
- **Short blinks (fault):** 150 ms on, 150 ms off
- **Between sequences:** 1 s pause, then the pattern repeats
- **Solid on:** LED stays on continuously (no blink)

## Status patterns (long blinks)

Count the long blinks in each repeating sequence:

| Blinks | State | When shown |
| --- | --- | --- |
| `2` | BOOT | Power-on / early boot (brief, before main state machine) |
| `3` | SETUP | BLE advertising; waiting for the mobile app |
| `4` | WIFI_CONNECTING | Attempting WiFi connect |
| `5` | PROVISIONING | WiFi connected during setup; waiting for cloud/device config from the app |

## Healthy (solid on)

| Pattern | State | When shown |
| --- | --- | --- |
| Solid on | PROVISIONED | Device fully provisioned and healthy (WiFi up, cloud reachable, Modbus read and upload OK) |

## Off

The LED is **off** only during the brief power-on window before `initStatusLed()` runs.
After that, a status or fault pattern is always active.

## Fault patterns (short blinks)

Count the short blinks in each repeating sequence:

| Blinks | State | When shown |
| --- | --- | --- |
| `2` | SN_READ_FAILED | Inverter serial number could not be read at boot; device halts until reboot |
| `3` | WIFI_FAILED | WiFi connect failed or connection lost |
| `4` | SN_MISMATCH | Cached serial number does not match expected value from NVS; device halts until reboot |
| `5` | PROVISION_FAILED | Device configuration write rejected during BLE provisioning |
| `6` | CLOUD_UNREACHABLE | WiFi up but Supabase unreachable (`supabaseBegin` failure, snapshot upload failure) |
| `7` | MODBUS_FAILED | Scheduled Modbus inverter poll failed; device enters backoff before retrying |

## Behaviour notes

- Fault and status share one LED; whichever state was set most recently applies after the current sequence completes.
- **Recovery:** a successful snapshot upload sets the LED back to **PROVISIONED** (solid on). A successful Modbus read followed by a successful upload also clears **MODBUS_FAILED**.
- Modbus communication failures are reported separately from cloud failures — they do not show **CLOUD_UNREACHABLE**.
- During BLE provisioning, the LED progresses roughly: SETUP → WIFI_CONNECTING → PROVISIONING → PROVISIONED (or a fault code on failure).
- After provisioned boot, the LED progresses roughly: BOOT → WIFI_CONNECTING → PROVISIONED (or a fault code on failure).
- BLE is active only while the device is unprovisioned and in the provisioning flow.

See `firmware/include/status_led.h` and `firmware/src/status_led.cpp` for the implementation.
