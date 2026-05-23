import "@supabase/functions-js/edge-runtime.d.ts";
import { SupabaseClient } from "@supabase/supabase-js";
import { withSupabase } from "@supabase/server";

import { Database, Json } from "../../database.types.ts";
import { deviceAuth } from "../_shared/device_auth.ts";

import { jsonError, parseJsonBody } from "../_shared/http.ts";

type EventPayload = {
  "inverter_id": string;
  "code": string;
  "level": string;
  "message": string | null | undefined;
  "metadata": Json | null | undefined;
  "recorded_at": string;
};

export default {
  fetch: withSupabase({ auth: "none" }, async (req, ctx) => {
    const supabaseAdmin = ctx.supabaseAdmin as SupabaseClient<Database>;

    const deviceAuthResponse = await deviceAuth(req, supabaseAdmin);

    // If deviceAuth returns a Response, it's an error response that should
    // be returned directly.
    if (deviceAuthResponse.error) {
      return deviceAuthResponse.error;
    }

    const gateway = deviceAuthResponse.gateway!;

    const body = await parseJsonBody<EventPayload>(req);
    if (!body || !body.code || !body.recorded_at) {
      return jsonError(
        400,
        "invalid_request",
        "Request body must be valid JSON.",
      );
    }

    // If body or gateway contains an inverter_id, they must match.
    if (gateway.inverter_id && body.inverter_id !== gateway.inverter_id) {
      return jsonError(
        400,
        "inverter_mismatch",
        "The event inverter_id does not match the gateway.",
      );
    }

    const eventReq = await supabaseAdmin
      .from("gateway_events")
      .insert({
        gateway_id: gateway.id,
        inverter_id: gateway.inverter_id ?? body.inverter_id,
        code: body.code,
        level: body.level,
        message: body.message,
        metadata: body.metadata,
        recorded_at: body.recorded_at,
      })
      .select()
      .maybeSingle();

    if (eventReq.error) {
      return jsonError(500, "database_error", eventReq.error.message);
    }

    if (!eventReq.data) {
      return jsonError(500, "database_error", "Failed to insert event");
    }

    return Response.json({
      ok: true,
      event_id: eventReq.data.id,
    });
  }),
};

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/ingest_event' \
    --header 'apiKey: sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH' \
    --data '{
      "inverter_id": "inverter-123",
      "code": "sn_mismatch",
      "level": "error",
      "message": "Serial number mismatch detected",
      "metadata": {
        "expected_sn": "SN12345678",
        "reported_sn": "SN87654321"
      },
      "recorded_at": "2024-01-01T12:00:00Z"
    }'
*/
