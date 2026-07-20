# Growatt SPA Profile (firmware)

This document summarizes the register mapping and runtime expectations for the `growatt_spa` profile used by the firmware (v1).

Hardware & Modbus:

- MCU: ESP32
- UART: `UART2` (RX=GPIO16, TX=GPIO17)
- Serial: 9600 8N1
- Modbus slave ID: 1
- SN read: FC `0x03`, registers 23–27 (5 registers → 10 ASCII chars)
- Telemetry: FC `0x04` input registers in blocks (see below)
- Solar power: FC `0x04` registers **1131–1132** (`ExtraACPower`, connected PV inverter)
- Solar energy today: FC `0x04` registers **1133–1134** (`Eextra today`), not Eac today (2053–2054) or EPVAll (1149–1150)
- Grid import power upload: **1021–1022** (`PactouserTotal`), not Pac (2035–2036)
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
- 32-bit values: high register then low register: `(hi << 16) | lo`.
- Use **signed** decode (`i32` / `i16`) for values that can be negative:
  - Pac (2035–2036) — signed `i32` @ 0.1 W
  - BMS battery current (1088) — signed `i16` @ 0.01 A
- Energy counters and one-way magnitudes use unsigned `u32` / `u16`.
- Scaling helpers: `u16_scaled`, `i16_scaled`, `u32_scaled`, `i32_scaled` in `profile_growatt.cpp`.

Snapshot upload mapping (JSON → `inverter_snapshots`):

| Column | Source |
| --- | --- |
| `solar_power_w` | ExtraACPower (1131–1132) |
| `solar_energy_today_kwh` | Eextra today (1133–1134) |
| `grid_active_power_w` | PactouserTotal import (1021–1022) |
| `grid_export_power_w` | Pactogrid total (1029–1030) |
| `home_load_power_w` | PLocalLoad total (1037–1038) |

The app computes net grid as `grid_active_power_w − grid_export_power_w` (positive = importing).

Notes:

- Boot SN is read once per power cycle and cached in RAM for BLE display and SN_CHECK on reboot.
- A Modbus read failure prevents snapshot creation and triggers a `modbus_failed` event with a 30-minute backoff.

For implementation details, inspect `firmware/src/profile_growatt.cpp` and the Growatt protocol reference in `vendor/`.
