# Conventions

## Domain terms

Use these terms consistently in UI copy, docs, and product language.

| Term | Meaning | Cardinality |
| --- | --- | --- |
| **System** | The gateway and inverter together with their location. The unit a user manages in the app. | Many per user |
| **Inverter** | The solar inverter hardware that produces and manages energy for the installation. | Max one per system |
| **Gateway** | The Grobase hardware that connects to the inverter (via Modbus) and to the cloud. Prefer **gateway** / **gateways** over **device** / **devices** when referring to this hardware. | Max one per system |

### Wording notes

- Prefer **gateway** / **gateways** in user-facing copy for the Grobase hardware.
- Keep **device** only when it clearly means something else (for example the user's phone: "device settings", theme preference "Device").
- BLE advertising name for setup remains `GroBase-Setup` (product identity, not a domain synonym).
