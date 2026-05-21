export function jsonError(status: number, error: string, message: string): Response {
  return Response.json({ error, message }, { status });
}

export async function parseJsonBody<T>(req: Request): Promise<T | null> {
  try {
    return (await req.json()) as T;
  } catch {
    return null;
  }
}

export function toTrimmedString(value: string | null | undefined): string {
  return typeof value === "string" ? value.trim() : "";
}