import "@supabase/functions-js/edge-runtime.d.ts";
import { withSupabase } from "@supabase/server";
import { SupabaseClient } from "@supabase/supabase-js";

import { Database } from "../../database.types.ts";
import { Database as Auth} from "../../auth.types.ts";
import { jsonError, parseJsonBody, toTrimmedString } from "../_shared/http.ts";

type RequestPayload = {
  token: string;
};

// A function to preview an invite token, showing the associated
// inverter's display name, the invite's expiration date, and the
// invite's status (pending, used, expired, or revoked).
export default {
  fetch: withSupabase({ auth: "none" }, async (req, ctx) => {
    const supabaseAdmin = ctx.supabaseAdmin as SupabaseClient<Database>;
    const supabaseAdminAuth = ctx.supabaseAdmin as SupabaseClient<Auth>;

    const body = await parseJsonBody<RequestPayload>(req);
    if (!body) {
      return jsonError(
        400,
        "invalid_request",
        "Request body must be valid JSON.",
      );
    }

    const token = toTrimmedString(body.token);
    if (!token) {
      return jsonError(
        400,
        "invalid_request",
        "Missing token in request body",
      );
    }

    const tokenReq = await supabaseAdmin
      .from("inverter_invites")
      .select("*")
      .eq("token", token)
      .maybeSingle();

    if (tokenReq.error) {
      return jsonError(500, "database_error", tokenReq.error.message);
    }

    if (!tokenReq.data) {
      return jsonError(404, "not_found", "Invite not found");
    }

    let status: "pending" | "expired" | "used" | "revoked" = "pending";

    if (tokenReq.data.accepted_at) {
      status = "used";
    } else if (tokenReq.data.revoked_at) {
      status = "revoked";
    } else if (new Date(tokenReq.data.expires_at) < new Date()) {
      status = "expired";
    }

    const inverterName = (await supabaseAdmin
      .from("inverters")
      .select("display_name")
      .eq("id", tokenReq.data.inverter_id)
      .maybeSingle()).data?.display_name ?? null;
    
    const invitedByEmail = (await supabaseAdminAuth
      .schema("auth")
      .from("users")
      .select("email")
      .eq("id", tokenReq.data.invited_by)
      .maybeSingle()).data?.email ?? null;

    return Response.json({
      status: status,
      invited_by_email: invitedByEmail,
      inverter_display_name: inverterName,
      expires_at: tokenReq.data.expires_at,
    });
  }),
};

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/get_invite_preview' \
    --header 'apiKey: sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH' \
    --data '{"token":"your_invite_token"}'

*/
