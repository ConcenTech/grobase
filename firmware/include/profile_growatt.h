#pragma once

// Growatt SPA profile: maps Modbus register tables to an
// `InverterSnapshot`. Profiles encapsulate register ranges and
// decoding logic so support for new models can be added modularly.

#include "inverter_snapshot.h"

void profileGrowattFill(InverterSnapshot *out, const uint16_t *r1009, const uint16_t *r1086,
                        const uint16_t *r1124, const uint16_t *r2035, const uint16_t *r2097,
                        const uint16_t *r2112);
