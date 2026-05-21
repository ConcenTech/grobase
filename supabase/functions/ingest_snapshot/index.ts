import { withSupabase } from "@supabase/server";
import { SupabaseClient } from "@supabase/supabase-js";

import { Database } from "../../database.types.ts";

import { sha256Hex, timingSafeEqualHex } from "../_shared/crypto.ts";
import { jsonError, parseJsonBody, toTrimmedString } from "../_shared/http.ts";

type SnapshotPayload = {
  inverter_id: string;
  recorded_at: string;
  battery_soc_percent?: number | null;
  battery_voltage_v?: number | null;
  battery_current_a?: number | null;
  battery_charge_power_w?: number | null;
  battery_discharge_power_w?: number | null;
  battery_charge_energy_today_kwh?: number | null;
  battery_discharge_energy_today_kwh?: number | null;
  grid_active_power_w?: number | null;
  grid_frequency_hz?: number | null;
  grid_voltage_v?: number | null;
  grid_current_a?: number | null;
  grid_export_power_w?: number | null;
  grid_export_energy_today_kwh?: number | null;
  grid_import_energy_today_kwh?: number | null;
  grid_charge_power_w?: number | null;
  solar_energy_today_kwh?: number | null;
  solar_power_w?: number | null;
  home_load_power_w?: number | null;
};

function toOptionalNumber(value: unknown): number | null | undefined {
  if (value === undefined) {
    return undefined;
  }

  if (value === null) {
    return null;
  }

  if (typeof value === "number" && Number.isFinite(value)) {
    return value;
  }

  return undefined;
}

function snapshotInsertFromBody(body: SnapshotPayload, gatewayId: string) {
  return {
    inverter_id: body.inverter_id,
    gateway_id: gatewayId,
    recorded_at: body.recorded_at,
    battery_soc_percent: toOptionalNumber(body.battery_soc_percent),
    battery_voltage_v: toOptionalNumber(body.battery_voltage_v),
    battery_current_a: toOptionalNumber(body.battery_current_a),
    battery_charge_power_w: toOptionalNumber(body.battery_charge_power_w),
    battery_discharge_power_w: toOptionalNumber(body.battery_discharge_power_w),
    battery_charge_energy_today_kwh: toOptionalNumber(
      body.battery_charge_energy_today_kwh,
    ),
    battery_discharge_energy_today_kwh: toOptionalNumber(
      body.battery_discharge_energy_today_kwh,
    ),
    grid_active_power_w: toOptionalNumber(body.grid_active_power_w),
    grid_frequency_hz: toOptionalNumber(body.grid_frequency_hz),
    grid_voltage_v: toOptionalNumber(body.grid_voltage_v),
    grid_current_a: toOptionalNumber(body.grid_current_a),
    grid_export_power_w: toOptionalNumber(body.grid_export_power_w),
    grid_export_energy_today_kwh: toOptionalNumber(
      body.grid_export_energy_today_kwh,
    ),
    grid_import_energy_today_kwh: toOptionalNumber(
      body.grid_import_energy_today_kwh,
    ),
    grid_charge_power_w: toOptionalNumber(body.grid_charge_power_w),
    solar_energy_today_kwh: toOptionalNumber(body.solar_energy_today_kwh),
    solar_power_w: toOptionalNumber(body.solar_power_w),
    home_load_power_w: toOptionalNumber(body.home_load_power_w),
  };
}

export default {
  fetch: withSupabase({ auth: "none" }, async (req, ctx) => {
    const supabase = ctx.supabase as SupabaseClient<Database>;
    const supabaseAdmin = ctx.supabaseAdmin as SupabaseClient<Database>;
    const gatewayId = toTrimmedString(req.headers.get("x-gateway-id"));
    const deviceSecret = req.headers.get("x-device-secret")?.trim() ?? "";

    if (!gatewayId || !deviceSecret) {
      return jsonError(401, "invalid_credentials", "Invalid credentials.");
    }

    const { data: gateway, error } = await supabase
      .from("gateways")
      .select("id, inverter_id, status, device_secret_hash")
      .eq("id", gatewayId)
      .maybeSingle();

    if (error) {
      return jsonError(500, "database_error", error.message);
    }

    if (!gateway || !gateway.device_secret_hash) {
      return jsonError(401, "invalid_credentials", "Invalid credentials.");
    }

    if (gateway.status !== "active") {
      return jsonError(403, "gateway_inactive", "Gateway is not active.");
    }

    const incomingSecretHash = await sha256Hex(deviceSecret);
    if (!timingSafeEqualHex(incomingSecretHash, gateway.device_secret_hash)) {
      return jsonError(401, "invalid_credentials", "Invalid credentials.");
    }

    const body = await parseJsonBody<SnapshotPayload>(req);
    if (!body) {
      return jsonError(
        400,
        "invalid_request",
        "Request body must be valid JSON.",
      );
    }

    const inverterId = toTrimmedString(body.inverter_id);
    const recordedAt = toTrimmedString(body.recorded_at);

    if (!inverterId || !recordedAt) {
      return jsonError(
        400,
        "invalid_request",
        "inverter_id and recorded_at are required.",
      );
    }

    if (gateway.inverter_id !== inverterId) {
      return jsonError(
        400,
        "inverter_mismatch",
        "The snapshot inverter_id does not match the gateway.",
      );
    }

    const snapshotInsert = await supabaseAdmin
      .from("inverter_snapshots")
      .insert(
        snapshotInsertFromBody({
          ...body,
          inverter_id: inverterId,
          recorded_at: recordedAt,
        }, gateway.id),
      )
      .select("id")
      .single();

    if (snapshotInsert.error) {
      return jsonError(500, "database_error", snapshotInsert.error.message);
    }

    const lastSeenAt = new Date().toISOString();

    const updateGateway = await supabase
      .from("gateways")
      .update({ last_seen_at: lastSeenAt })
      .eq("id", gateway.id)
      .select("id")
      .single();

    if (updateGateway.error) {
      return jsonError(500, "database_error", updateGateway.error.message);
    }

    const updateInverter = await supabase
      .from("inverters")
      .update({ last_seen_at: lastSeenAt })
      .eq("id", inverterId)
      .select("id")
      .single();

    if (updateInverter.error) {
      return jsonError(500, "database_error", updateInverter.error.message);
    }

    if (!snapshotInsert.data) {
      return jsonError(
        500,
        "database_error",
        "Failed to create snapshot record.",
      );
    }

    return Response.json({ ok: true, snapshot_id: snapshotInsert.data.id }, {
      status: 201,
    });
  }),
};
