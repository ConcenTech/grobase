import {
  assert,
  assertEquals,
  assertNotEquals,
} from "@std/assert";

import {
  generateDeviceSecret,
  normalizeInverterSn,
  sha256Hex,
  timingSafeEqualHex,
} from "./crypto.ts";

Deno.test("normalizeInverterSn trims and uppercases", () => {
  assertEquals(normalizeInverterSn("  abcd1234  "), "ABCD1234");
});

Deno.test("sha256Hex hashes known input", async () => {
  assertEquals(
    await sha256Hex("abc"),
    "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
  );
});

Deno.test("timingSafeEqualHex compares hex values", () => {
  assert(timingSafeEqualHex("0a0b", "0A0B"));
  assertNotEquals(timingSafeEqualHex("0a0b", "0a0c"), true);
});

Deno.test("generateDeviceSecret returns 64 hex chars", () => {
  const secret = generateDeviceSecret();
  assertEquals(secret.length, 64);
  assert(/^[0-9a-f]+$/.test(secret));
});