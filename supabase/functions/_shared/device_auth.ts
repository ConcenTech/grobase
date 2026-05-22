import { SupabaseClient } from "@supabase/supabase-js";
import bcrypt from "bcryptjs";

import { Database } from "../../database.types.ts";
import { jsonError } from "./http.ts";

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
  const gatewayId = request.headers.get("x-gateway-id");
  const deviceSecret = request.headers.get("x-device-secret");

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

  const {device_secret_hash, ...gateway} = gatewayReq.data;

  const isMatch = await bcrypt.compare(
    deviceSecret,
    device_secret_hash,
  );

  if (!isMatch) {
    return jsonError(401, "invalid_credentials", "Invalid device secret");
  }

  return gateway as Gateway;
}
