-- Align Data API privileges with RLS + edge-function clients.
-- Hosted projects owned by postgres no longer auto-grant CRUD to
-- authenticated/service_role. Without these grants PostgREST returns
-- 42501 or PGRST205 ("table not in schema cache"), which surfaces in
-- the app as a sync failure after login while Auth still works.

-- authenticated: only what RLS policies already allow.
grant select, update, delete on table public.inverters to authenticated;
grant select, delete on table public.inverter_members to authenticated;
grant select, insert, update on table public.inverter_invites to authenticated;
grant select on table public.inverter_snapshots to authenticated;
grant select on table public.gateway_events to authenticated;

-- gateways: no direct authenticated access (deny-all + get_gateways_safe).

grant execute on function public.revoke_invite(uuid) to authenticated;
revoke execute on function public.revoke_invite(uuid) from anon;

-- service_role: edge functions (register/ingest/accept/preview/device_auth).
grant select, insert, update, delete on table
  public.inverters,
  public.inverter_members,
  public.gateways,
  public.inverter_invites,
  public.inverter_snapshots,
  public.gateway_events
to service_role;

grant usage, select, update on all sequences in schema public to service_role;

-- Add missing policy to allow owners to invite members.
create policy inverter_invites_insert_owner
  on public.inverter_invites
  for insert
  to authenticated
  with check (
    public.is_inverter_owner(inverter_id)
    and invited_by = auth.uid()
  );

-- Keep anon off table data (reinforces initial migration).
revoke all on table
  public.inverters,
  public.inverter_members,
  public.gateways,
  public.inverter_invites,
  public.inverter_snapshots,
  public.gateway_events
from anon;
