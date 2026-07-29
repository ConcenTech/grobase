import "@supabase/functions-js/edge-runtime.d.ts";
import { withSupabase } from "@supabase/server";
import { SupabaseClient } from "@supabase/supabase-js";

import { Database } from "../../database.types.ts";
import { jsonError, parseJsonBody, toTrimmedString } from "../_shared/http.ts";

type RequestPayload = {
  inverter_id: string;
};

export default {
  fetch: withSupabase({ auth: "user" }, async (req, ctx) => {
    const supabase = ctx.supabase as SupabaseClient<Database>;

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

    const inverter_id = toTrimmedString(body.inverter_id);
    if (!inverter_id) {
      return jsonError(
        400,
        "invalid_request",
        "Missing inverter_id in request body",
      );
    }

    // Get the inverter member record where this user is an owner.
    const inverterMemberReq = await supabase
      .from("inverter_members")
      .select("*")
      .eq("inverter_id", inverter_id)
      .eq("user_id", caller.id)
      .eq("role", "owner")
      .maybeSingle();

    if (inverterMemberReq.error) {
      return jsonError(500, "database_error", inverterMemberReq.error.message);
    }

    // If the user is not a member of the inverter, return an error
    if (!inverterMemberReq.data) {
      return jsonError(
        403,
        "forbidden",
        "You must be an owner of the inverter to create an invite link",
      );
    }

    // Generate a random invite token, set expiry to 7 days.
    const invite_token = crypto.randomUUID().toString();
    const token_expiry = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // 7 days from now

    // Insert the invite token into the database
    const inviteReq = await supabase.from("inverter_invites")
      .insert({
        inverter_id: inverter_id,
        token: invite_token,
        created_at: new Date().toISOString(),
        expires_at: token_expiry.toISOString(),
        invited_by: caller.id,
      }).select("*")
      .single();

    if (inviteReq.error) {
      return jsonError(500, "database_error", inviteReq.error.message);
    }

    const baseUrl = toTrimmedString(Deno.env.get("INVITE_BASE_URL"));

    if (!baseUrl) {
      return jsonError(
        500,
        "server_configuration_error",
        "INVITE_BASE_URL environment variable is not set",
      );
    }
    
    // https://<base_url>/invite/?token=...
    const shareLink = `${baseUrl}/invite/?token=${invite_token}`;

    return Response.json({
      invite_id: inviteReq.data.id,
      token: invite_token,
      "invite_url": shareLink,
      "expires_at": token_expiry.toISOString(),
    });
  }),
};
