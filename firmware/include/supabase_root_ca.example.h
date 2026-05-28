#pragma once

#include <Arduino.h>

// Copy this file to `supabase_root_ca.h` and paste the PEM for your Supabase
// root CA certificate into SUPABASE_ROOT_CA_PEM.
//
// Example:
//   static const char SUPABASE_ROOT_CA_PEM[] PROGMEM = R"PEM(
//   -----BEGIN CERTIFICATE-----
//   ...
//   -----END CERTIFICATE-----
//   )PEM";

static const char SUPABASE_ROOT_CA_PEM[] PROGMEM = "";
