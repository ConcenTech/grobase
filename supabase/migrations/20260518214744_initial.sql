-- Table: inverters
create table public.inverters (
  id uuid primary key default gen_random_uuid(),
  inverter_sn text not null unique,
  profile text not null,
  display_name text,
  last_seen_at timestamptz,
  created_at timestamptz not null default now()
);

-- Table: inverter_members
create table public.inverter_members (
  inverter_id uuid not null references public.inverters (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  role text not null check (role in ('owner', 'viewer')),
  created_at timestamptz not null default now(),
  primary key (inverter_id, user_id)
);

create index inverter_members_user_id_idx on public.inverter_members (user_id);
create unique index inverter_one_owner_idx on public.inverter_members (inverter_id) where role = 'owner';

-- Table: gateways
create table public.gateways (
  id uuid primary key default gen_random_uuid(),
  hardware_id text not null unique,
  inverter_id uuid references public.inverters (id) on delete cascade,
  status text not null check (status in ('pending', 'active', 'retired')) default 'pending',
  device_secret_hash text,
  provisioned_by uuid references auth.users (id),
  last_seen_at timestamptz,
  firmware_version text,
  created_at timestamptz not null default now(),
  retired_at timestamptz
);

create unique index gateway_one_active_per_inverter_idx on public.gateways (inverter_id) where status = 'active';
create index gateways_inverter_id_idx on public.gateways (inverter_id);

-- Table: inverter_invites
create table public.inverter_invites (
  id uuid primary key default gen_random_uuid(),
  inverter_id uuid not null references public.inverters (id) on delete cascade,
  role text not null check (role in ('owner', 'viewer')) default 'viewer',
  token text not null unique,
  invited_by uuid not null references auth.users (id),
  accepted_by uuid references auth.users (id),
  expires_at timestamptz not null,
  accepted_at timestamptz,
  revoked_at timestamptz,
  created_at timestamptz not null default now()
);

create index inverter_invites_inverter_id_idx on public.inverter_invites (inverter_id);

-- Table: inverter_snapshots
create table public.inverter_snapshots (
  id bigint primary key generated always as identity,
  inverter_id uuid not null references public.inverters (id) on delete cascade,
  gateway_id uuid references public.gateways (id) on delete set null,
  recorded_at timestamptz not null,
  ingested_at timestamptz not null default now(),
  battery_soc_percent double precision,
  battery_voltage_v double precision,
  battery_current_a double precision,
  battery_charge_power_w double precision,
  battery_discharge_power_w double precision,
  battery_charge_energy_today_kwh double precision,
  battery_discharge_energy_today_kwh double precision,
  grid_active_power_w double precision,
  grid_frequency_hz double precision,
  grid_voltage_v double precision,
  grid_current_a double precision,
  grid_export_power_w double precision,
  grid_export_energy_today_kwh double precision,
  grid_import_energy_today_kwh double precision,
  grid_charge_power_w double precision,
  solar_energy_today_kwh double precision,
  solar_power_w double precision,
  home_load_power_w double precision
);

create index inverter_snapshots_inverter_recorded_idx on public.inverter_snapshots (inverter_id, recorded_at desc);

-- Table: gateway_events
create table public.gateway_events (
  id bigint primary key generated always as identity,
  gateway_id uuid not null references public.gateways (id) on delete cascade,
  inverter_id uuid not null references public.inverters (id) on delete cascade,
  level text not null check (level in ('info', 'warn', 'error')),
  code text not null,
  message text,
  metadata jsonb,
  recorded_at timestamptz not null,
  ingested_at timestamptz not null default now()
);

create index gateway_events_inverter_recorded_idx on public.gateway_events (inverter_id, recorded_at desc);
create index gateway_events_gateway_recorded_idx on public.gateway_events (gateway_id, recorded_at desc);

-- View: gateways_safe (omits device_secret_hash)
create view public.gateways_safe with (security_invoker = true) as
select id, hardware_id, inverter_id, status, provisioned_by, last_seen_at, firmware_version, created_at, retired_at
from public.gateways;

-- Helper functions
create or replace function public.is_inverter_member(p_inverter_id uuid) returns boolean
language sql security invoker set search_path = public stable as $$
  select exists (select 1 from inverter_members where inverter_id = p_inverter_id and user_id = auth.uid());
$$;

grant execute on function public.is_inverter_member(uuid) to authenticated;
revoke execute on function public.is_inverter_member(uuid) from anon;

create or replace function public.is_inverter_owner(p_inverter_id uuid) returns boolean
language sql security invoker set search_path = public stable as $$
  select exists (select 1 from inverter_members where inverter_id = p_inverter_id and user_id = auth.uid() and role = 'owner');
$$;

grant execute on function public.is_inverter_owner(uuid) to authenticated;
revoke execute on function public.is_inverter_owner(uuid) from anon;

-- Enable RLS
alter table public.inverters enable row level security;
alter table public.inverter_members enable row level security;
alter table public.gateways enable row level security;
alter table public.inverter_invites enable row level security;
alter table public.inverter_snapshots enable row level security;
alter table public.gateway_events enable row level security;

-- RLS Policies
create policy inverters_select_member on public.inverters for select to authenticated using (public.is_inverter_member(id));
create policy inverters_update_owner on public.inverters for update to authenticated using (public.is_inverter_owner(id)) with check (public.is_inverter_owner(id));
create policy inverters_delete_owner on public.inverters for delete to authenticated using (public.is_inverter_owner(id));

create policy inverter_members_select_owner on public.inverter_members for select to authenticated using (public.is_inverter_owner(inverter_id));
create policy inverter_members_delete_by_owner on public.inverter_members for delete to authenticated using (public.is_inverter_owner(inverter_id) and role = 'viewer');
create policy inverter_members_delete_leave on public.inverter_members for delete to authenticated using (user_id = auth.uid() and role = 'viewer');

create policy inverter_invites_select_owner on public.inverter_invites for select to authenticated using (public.is_inverter_owner(inverter_id));
create policy inverter_invites_update_owner on public.inverter_invites for update to authenticated using (public.is_inverter_owner(inverter_id)) with check (public.is_inverter_owner(inverter_id));

create policy inverter_snapshots_select_member on public.inverter_snapshots for select to authenticated using (public.is_inverter_member(inverter_id));

create policy gateway_events_select_owner on public.gateway_events for select to authenticated using (public.is_inverter_owner(inverter_id));

-- Provide a secure, per-row filtered accessor for owners
CREATE OR REPLACE FUNCTION public.get_gateways_safe()
RETURNS TABLE (
  id uuid,
  hardware_id text,
  inverter_id uuid,
  status text,
  provisioned_by uuid,
  last_seen_at timestamptz,
  firmware_version text,
  created_at timestamptz,
  retired_at timestamptz
)
SECURITY DEFINER
SET search_path = public
LANGUAGE sql
STABLE
AS $$
  SELECT g.id, g.hardware_id, g.inverter_id, g.status,
         g.provisioned_by, g.last_seen_at, g.firmware_version, g.created_at, g.retired_at
  FROM public.gateways g
  WHERE public.is_inverter_owner(g.inverter_id);
$$;

GRANT EXECUTE ON FUNCTION public.get_gateways_safe() TO authenticated;
REVOKE EXECUTE ON FUNCTION public.get_gateways_safe() FROM anon;

-- Revoke SELECT from anon role on all tables and views
REVOKE SELECT ON public.inverters FROM anon;
REVOKE SELECT ON public.inverter_members FROM anon;
REVOKE SELECT ON public.gateways FROM anon;
REVOKE SELECT ON public.inverter_invites FROM anon;
REVOKE SELECT ON public.inverter_snapshots FROM anon;
REVOKE SELECT ON public.gateway_events FROM anon;
REVOKE SELECT ON public.gateways_safe FROM anon;

-- Explicit deny-all policy on gateways (app accesses via get_gateways_safe() function only)
create policy gateways_deny_all on public.gateways for select using (false);