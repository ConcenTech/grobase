# Growatt SPA Profile (firmware)

This document summarizes the register mapping and runtime expectations for the `growatt_spa` profile used by the firmware (v1).

Hardware & Modbus:

- MCU: ESP32
- UART: `UART2` (RX=GPIO16, TX=GPIO17)
- Serial: 9600 8N1
- Modbus slave ID: 1
- SN read: FC `0x03`, registers 23–27 (5 registers → 10 ASCII chars)
- Telemetry: FC `0x04` input registers in blocks (see below)
- Solar energy today: FC `0x04` registers **2053–2054** (`Eac today`, SPA "Today generate energy"), not 1149–1150
- Battery voltage for upload: prefer **2097** (`BatVolt_DSP`) or **1013** (`Vbat`) over **1087** (`BMS_BatteryVolt`, SPH6K)

Register blocks used by firmware v1 (prototype ranges):

- `r1009` (start=1009, count=51)
- `r1086` (start=1086, count=3)
- `r1124` (start=1124, count=27)
- `r2035` (start=2035, count=20)
- `r2097` (start=2097, count=1)
- `r2112` (start=2112, count=6)

Decoding rules:

- Per-register big-endian (high byte first).
- 32-bit values: high register then low register: `u32 = (hi << 16) | lo`.
- Scaling per-profile mapping; helper functions `u16_scaled` and `u32_scaled` used in `profile_growatt.cpp`.

Snapshot output:

Firmware fills an `InverterSnapshot` structure and prints JSON for debug; fields include battery power/energy, SOC, grid power/voltage/current, PV energy, and local load power. See `firmware/src/profile_growatt.cpp` and `firmware/src/inverter_snapshot.cpp`.

Notes:

- Boot SN is read once per power cycle and cached in RAM for BLE display and SN_CHECK on reboot.
- A Modbus read failure prevents snapshot creation and triggers a `modbus_failed` event with a 30-minute backoff.

For implementation details, inspect `firmware/src/profile_growatt.cpp` and the Growatt protocol reference in `vendor/`.
