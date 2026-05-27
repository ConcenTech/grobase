# LED Fault & Status Codes

This document lists the onboard LED status and fault patterns used by the firmware.

Status (long blinks, repeating):

- `1` — BOOT: early boot / UART init (brief)
- `2` — BLE_SETUP: BLE advertising / waiting for app
- `3` — WIFI_CONNECTING: attempting WiFi connect
- `4` — SN_READ: boot SN read in progress (brief)

Fault (short blinks, override status):

- `2` — SN_READ_FAILED: boot SN read failed (device halts until reboot)
- `3` — WIFI_UNREACHABLE: WiFi failed or lost (provisioned device)
- `4` — SN_MISMATCH: `FAULT_SN` when cloud unreachable
- `5` — CLOUD_UNREACHABLE: WiFi up; ingest HTTP/TLS unreachable

Behaviour notes:

- Fault patterns override status patterns.
- Between sequences there is a ~2s pause before repeating.
- Clearing a fault: when the corresponding `ingest_event` is successfully uploaded (or on reboot), firmware clears the fault code.

See `firmware/src/status_led.cpp` for the exact timing constants and test hooks.
