import { SupabaseClient } from "@supabase/supabase-js";
import { sha256Hex, timingSafeEqualHex } from "./crypto.ts";

import { Database } from "../../database.types.ts";
import { jsonError, toTrimmedString } from "./http.ts";

type Gateway = {
  created_at: string;
  firmware_version: string | null;
  hardware_id: string;
  id: string;
  inverter_id: string | null;
  last_seen_at: string | null;
  provisioned_by: string | null;
  retired_at: string | null;
  status: string;
};

/**
 * An authentication guard for requests originating from devices.
 * It verifies the presence of the `x-gateway-id` and `x-device-secret`
 * headers, and checks that the provided device secret matches the
 * expected value for the given gateway ID.
 * @param request
 * @param database - The admin database
 * @returns The associated gateway and inverter_id
 */
export async function deviceAuth(
  request: Request,
  database: SupabaseClient<Database>,
) {
  const gatewayId = toTrimmedString(request.headers.get("x-gateway-id"));
  const deviceSecret = toTrimmedString(request.headers.get("x-device-secret"));

  if (!gatewayId || !deviceSecret) {
    return jsonError(
      401,
      "invalid_credentials",
      "Missing authentication headers",
    );
  }

  const gatewayReq = await database
    .from("gateways")
    .select("*")
    .eq("id", gatewayId)
    .maybeSingle();

  if (gatewayReq.error) {
    return jsonError(500, "database_error", gatewayReq.error.message);
  }

  if (!gatewayReq.data) {
    return jsonError(401, "invalid_credentials", "Gateway not found");
  }

  if (gatewayReq.data.status !== "active") {
    return jsonError(401, "invalid_credentials", "Gateway is not active");
  }

  if (!gatewayReq.data.device_secret_hash) {
    return jsonError(
      500,
      "internal_server_error",
      "Gateway is not properly configured",
    );
  }

  const { device_secret_hash, ...gateway } = gatewayReq.data;

  const incomingSecretHash = await sha256Hex(deviceSecret);
  if (!timingSafeEqualHex(incomingSecretHash, device_secret_hash)) {
    return jsonError(401, "invalid_credentials", "Invalid device secret");
  }

  return gateway as Gateway;
}
