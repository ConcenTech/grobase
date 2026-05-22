import "@supabase/functions-js/edge-runtime.d.ts";
import { withSupabase } from "@supabase/server";
import { SupabaseClient } from "@supabase/supabase-js";

import { Database } from "../../database.types.ts";
import { jsonError, parseJsonBody, toTrimmedString } from "../_shared/http.ts";

type RequestPayload = {
  invite_token: string;
};

// This function accepts an invite token, adding the user to the inverter's 
// members. 
// The user must be authenticated to use this function, and the invite token 
// must be valid (not expired, revoked, or already accepted).
//
// Once accepted, the invite is updated so that it cannot be used again.
export default {
  fetch: withSupabase({ auth: "user" }, async (req, ctx) => {
    const supabaseAdmin = ctx.supabaseAdmin as SupabaseClient<Database>;

    const caller = ctx.userClaims;
    if (!caller) {
      return jsonError(
        401,
        "unauthorized",
        "You must be authenticated to use this function",
      );
    }

    const body = await parseJsonBody<RequestPayload>(req);
    if (!body) {
      return jsonError(
        400,
        "invalid_request",
        "Request body must be valid JSON.",
      );
    }

    const token = toTrimmedString(body.invite_token);
    if (!token) {
      return jsonError(
        400,
        "invalid_request",
        "Missing invite_token in request body",
      );
    }

    // Get invite request to ensure it's still valid
    const invite = await supabaseAdmin
      .from("inverter_invites")
      .select("*")
      .eq("token", token)
      .maybeSingle();

    if (invite.error) {
      return jsonError(500, "database_error", invite.error.message);
    }

    if (!invite.data) {
      return jsonError(404, "not_found", "Invite not found");
    }

    if (invite.data.accepted_at) {
      return jsonError(422, "invalid_request", "Invite already accepted");
    } else if (invite.data.revoked_at) {
      return jsonError(422, "invalid_request", "Invite has been revoked");
    } else if (new Date(invite.data.expires_at) < new Date()) {
      return jsonError(422, "invalid_request", "Invite has expired");
    }
    
    // Add user as a member of the inverter with 'viewer' role
    const memberReq = await supabaseAdmin
      .from("inverter_members")
      .insert({
        inverter_id: invite.data.inverter_id,
        user_id: caller.id,
        role: "viewer",
      });

    if (memberReq.error) {
      return jsonError(500, "database_error", memberReq.error.message);
    }
    
    // Update the invite record to mark it as accepted
    const inviteUpdateReq = await supabaseAdmin
      .from("inverter_invites")
      .update({
        accepted_by: caller.id,
        accepted_at: new Date().toISOString(),
      })
      .eq("id", invite.data.id);

    if (inviteUpdateReq.error) {
      return jsonError(500, "database_error", inviteUpdateReq.error.message);
    }

    return Response.json({
      ok: true,
      inverter_id: invite.data.inverter_id,
    });
  }),
};

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/accept_invite' \
    --header 'apiKey: sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH' \
    --data '{"invite_token":"your_invite_token_here"}'

*/
