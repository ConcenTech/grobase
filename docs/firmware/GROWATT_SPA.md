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
- Solar / PV power for upload: **2102–2103** (`ExtraACPower to grid`, SPA CT2 / connected PV inverter). Doc also lists **1131–1132** under the same name, but that alias stays 0 on live SPA
- Grid import for upload (`grid_import_power_w`): **1021–1022** (`PactouserTotal`) — utility → house only
- Grid export for upload (`grid_export_power_w`): **1029–1030** (`Pactogrid total`) — house → utility only
- Do **not** use SPA **2035–2036** (`Pac`) for site grid: that is SPA AC-port power (mixes battery / AC-charge / local flows), not meter import/export
- Home load for upload (`home_load_power_w`): **1037–1038** (`PLocalLoad total`). Matches house use from grid + solar + battery (≈ import − export + solar − charge + discharge). Do **not** use **1145–1146** (`PSystem`) — that tracks PV when exporting
- Battery voltage for upload: prefer **2097** (`BatVolt_DSP`) or **1013** (`Vbat`) over **1087** (`BMS_BatteryVolt`)
- BMS **1087** / **1088**: decode as **0.01 V** and **signed 0.01 A** (protocol units blank; matches live SPA)
- SPA **2035–2036** `Pac`: still decoded (signed 0.1 W) for debug / frequency-adjacent block; not uploaded as grid
- AC charge energy today **1124–1125**: **0.1 kWh** (aligns with EACharge / live totals)

Register blocks used by firmware v1 (prototype ranges):

- `r1009` (start=1009, count=51)
- `r1086` (start=1086, count=3)
- `r1124` (start=1124, count=27)
- `r2035` (start=2035, count=20)
- `r2097` (start=2097, count=7; includes ExtraACPower 2102–2103)
- `r2112` (start=2112, count=6)

Decoding rules:

- Per-register big-endian (high byte first).
- 32-bit values: high register then low register: `(hi << 16) | lo` (signed or unsigned per field).
- Helpers: `u16_scaled`, `i16_scaled`, `u32_scaled`, `i32_scaled` in `profile_growatt.cpp`.

Snapshot output:

Firmware fills an `InverterSnapshot` structure and prints JSON for debug; fields include battery power/energy, SOC, grid power/voltage/current, PV energy, and local load power. See `firmware/src/profile_growatt.cpp` and `firmware/src/inverter_snapshot.cpp`.

Notes:

- Boot SN is read once per power cycle and cached in RAM for BLE display and SN_CHECK on reboot.
- A Modbus read failure prevents snapshot creation and triggers a `modbus_failed` event with a 30-minute backoff.
- `MODBUS_DEBUG=true` (PlatformIO build flag): after each normal poll, also reads FC04 ranges **1000–1043**, **1044–1066**, **1125–1249**, **2000–2124** and stores them in `inverter_snapshots.metadata.modbus_fc04` as `{ "1000":[...], "1044":[...], "1125":[...], "2000":[...] }`.

For implementation details, inspect `firmware/src/profile_growatt.cpp` and the Growatt protocol reference in `vendor/`.
