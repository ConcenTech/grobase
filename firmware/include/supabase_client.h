#// Public API: lightweight Supabase client interface used by the firmware.
#pragma once

#include "inverter_snapshot.h"

// Connect WiFi and obtain initial Supabase session (password grant).
bool supabaseBegin();

// Refresh access token if expired or missing.
bool supabaseEnsureAuth();

// POST one row to public.inverter_snapshots (requires authenticated JWT + RLS).
bool supabaseInsertSnapshot(const InverterSnapshot *snapshot);

// POST an operational event (gateway_events) via Edge Function.
// `metadata` may be an optional JSON string (or empty).
bool supabaseInsertEvent(const String &inverterId,
						 const String &code,
						 const String &level,
						 const String &message,
						 const String &metadata);
