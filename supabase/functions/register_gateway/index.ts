import { SupabaseClient } from "@supabase/supabase-js";
import { withSupabase } from "@supabase/server";

import { Database } from "../../database.types.ts";
import {
  generateDeviceSecret,
  normalizeInverterSn,
  sha256Hex,
} from "../_shared/crypto.ts";
import { jsonError, parseJsonBody, toTrimmedString } from "../_shared/http.ts";

type RegisterGatewayRequest = {
  mode: "new" | "replace";
  hardware_id: string;
  inverter_sn: string;
  profile?: string;
  inverter_id?: string | null;
};

export default {
  fetch: withSupabase({ auth: "user" }, async (req, ctx) => {
    const supabaseAdmin = ctx.supabaseAdmin as SupabaseClient<Database>;

    const body = await parseJsonBody<RegisterGatewayRequest>(req);
    if (!body) {
      return jsonError(
        400,
        "invalid_request",
        "Request body must be valid JSON.",
      );
    }

    const mode = body.mode;
    if (mode !== "new" && mode !== "replace") {
      return jsonError(
        400,
        "invalid_request",
        "mode must be 'new' or 'replace'.",
      );
    }

    const hardwareId = toTrimmedString(body.hardware_id);
    const inverterSnInput = toTrimmedString(body.inverter_sn);
    const profile = toTrimmedString(body.profile ?? "growatt_spa") ||
      "growatt_spa";
    const callerUserId = ctx.userClaims?.id;

    if (!callerUserId) {
      return jsonError(401, "unauthorized", "Invalid credentials.");
    }

    if (!hardwareId || !inverterSnInput) {
      return jsonError(
        400,
        "invalid_request",
        "hardware_id and inverter_sn are required.",
      );
    }

    const inverterSn = normalizeInverterSn(inverterSnInput);

    let inverterId = toTrimmedString(body.inverter_id ?? null);

    if (mode === "replace") {
      if (!inverterId) {
        return jsonError(
          400,
          "invalid_request",
          "inverter_id is required for replace mode.",
        );
      }
    }

    const { data: existingInverter, error } = await supabaseAdmin
      .from("inverters")
      .select("id, inverter_sn")
      .eq("inverter_sn", inverterSn)
      .maybeSingle();

    if (error) {
      return jsonError(500, "database_error", error.message);
    }

    if (mode === "replace") {
      if (!existingInverter || existingInverter.id !== inverterId) {
        return jsonError(
          400,
          "invalid_request",
          "inverter_sn does not match inverter_id.",
        );
      }

      const { data: owner, error } = await supabaseAdmin
        .from("inverter_members")
        .select("user_id, role")
        .eq("inverter_id", inverterId)
        .eq("role", "owner")
        .maybeSingle();

      if (error) {
        return jsonError(500, "database_error", error.message);
      }

      if (!owner || owner.user_id !== callerUserId) {
        return jsonError(
          403,
          "forbidden",
          "Only the owner can replace a gateway.",
        );
      }
    }

    if (mode === "new" && existingInverter) {
      const { data: owner, error } = await supabaseAdmin
        .from("inverter_members")
        .select("user_id, role")
        .eq("inverter_id", existingInverter.id)
        .eq("role", "owner")
        .maybeSingle();

      if (error) {
        return jsonError(500, "database_error", error.message);
      }

      if (owner && owner.user_id !== callerUserId) {
        return jsonError(
          409,
          "sn_already_claimed",
          "That inverter serial number is already claimed.",
        );
      }

      inverterId = existingInverter.id;
    }

    if (!existingInverter) {
      const { data: inverter, error } = await supabaseAdmin
        .from("inverters")
        .insert({
          inverter_sn: inverterSn,
          profile,
        })
        .select("id, inverter_sn")
        .single();

      if (error) {
        if (error.code === "23505") {
          return jsonError(
            409,
            "sn_already_claimed",
            "That inverter serial number is already claimed.",
          );
        }

        return jsonError(500, "database_error", error.message);
      }

      if (!inverter?.id) {
        return jsonError(
          500,
          "database_error",
          "Failed to create inverter record.",
        );
      }

      const memberInsert = await supabaseAdmin.from("inverter_members").upsert(
        {
          inverter_id: inverterId,
          user_id: callerUserId,
          role: "owner",
        },
        { onConflict: "inverter_id,user_id" },
      ).select("inverter_id, user_id").single();

      if (memberInsert.error) {
        return jsonError(500, "database_error", memberInsert.error.message);
      }
    } else {
      const ownerUpsert = await supabaseAdmin.from("inverter_members").upsert(
        {
          inverter_id: inverterId,
          user_id: callerUserId,
          role: "owner",
        },
        { onConflict: "inverter_id,user_id" },
      ).select("inverter_id, user_id").single();

      if (ownerUpsert.error) {
        return jsonError(500, "database_error", ownerUpsert.error.message);
      }
    }

    if (!inverterId) {
      return jsonError(500, "database_error", "Unable to resolve inverter id.");
    }

    const { data: existingGateway, error: gatewayLookupError } =
      await supabaseAdmin
        .from("gateways")
        .select("id, hardware_id, inverter_id, status, device_secret_hash")
        .eq("hardware_id", hardwareId)
        .maybeSingle();

    if (gatewayLookupError) {
      return jsonError(500, "database_error", gatewayLookupError.message);
    }

    if (
      existingGateway?.status === "active" &&
      existingGateway.inverter_id &&
      existingGateway.inverter_id !== inverterId
    ) {
      return jsonError(
        409,
        "hardware_id_in_use",
        "That hardware_id is already active on another inverter.",
      );
    }

    const deviceSecret = generateDeviceSecret();
    const deviceSecretHash = await sha256Hex(deviceSecret);

    if (existingGateway) {
      const updateGateway = await supabaseAdmin
        .from("gateways")
        .update({
          inverter_id: inverterId,
          status: "active",
          device_secret_hash: deviceSecretHash,
          provisioned_by: callerUserId,
        })
        .eq("id", existingGateway.id)
        .select("id, inverter_id")
        .single();

      if (updateGateway.error) {
        return jsonError(500, "database_error", updateGateway.error.message);
      }

      if (!updateGateway.data) {
        return jsonError(
          500,
          "database_error",
          "Failed to update gateway record.",
        );
      }

      return Response.json({
        gateway_id: updateGateway.data.id,
        inverter_id: updateGateway.data.inverter_id,
        device_secret: deviceSecret,
        inverter_sn: inverterSn,
      });
    }

    const gatewayInsert = await supabaseAdmin
      .from("gateways")
      .insert({
        hardware_id: hardwareId,
        inverter_id: inverterId,
        status: "active",
        device_secret_hash: deviceSecretHash,
        provisioned_by: callerUserId,
      })
      .select("id, inverter_id")
      .single();

    if (gatewayInsert.error) {
      if (gatewayInsert.error.code === "23505") {
        return jsonError(
          409,
          "hardware_id_in_use",
          "That hardware_id is already in use.",
        );
      }

      return jsonError(500, "database_error", gatewayInsert.error.message);
    }

    if (!gatewayInsert.data) {
      return jsonError(
        500,
        "database_error",
        "Failed to create gateway record.",
      );
    }

    return Response.json({
      gateway_id: gatewayInsert.data.id,
      inverter_id: gatewayInsert.data.inverter_id,
      device_secret: deviceSecret,
      inverter_sn: inverterSn,
    });
  }),
};
