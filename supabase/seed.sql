-- Local development seed data.
-- Demo login: demo@grobase.local / password123
-- Applied automatically on `supabase db reset` (see [db.seed] in config.toml).

create extension if not exists pgcrypto with schema extensions;

do $$
declare
  v_user_id uuid := 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
  v_inverter_id uuid := 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a22';
  v_gateway_id uuid := 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a33';
  v_inverter_id_2 uuid := 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a23';
  v_gateway_id_2 uuid := 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a34';
  v_inverter_id_3 uuid := 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a24';
  v_gateway_id_3 uuid := 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a35';
  v_email text := 'demo@grobase.local';
  v_password text := 'password123';
  v_now timestamptz := date_trunc('minute', now());
  v_start timestamptz := v_now - interval '24 hours';
  v_yesterday timestamptz := v_now - interval '1 day';
begin
  -- auth.users + auth.identities (required for email/password sign-in)
  insert into auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    confirmation_token,
    recovery_token,
    email_change_token_new,
    email_change,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at
  ) values (
    '00000000-0000-0000-0000-000000000000',
    v_user_id,
    'authenticated',
    'authenticated',
    v_email,
    extensions.crypt(v_password, extensions.gen_salt('bf')),
    v_now,
    '',
    '',
    '',
    '',
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"full_name":"Demo User"}'::jsonb,
    v_now,
    v_now
  );

  insert into auth.identities (
    id,
    user_id,
    identity_data,
    provider,
    provider_id,
    last_sign_in_at,
    created_at,
    updated_at
  ) values (
    v_user_id,
    v_user_id,
    jsonb_build_object('sub', v_user_id::text, 'email', v_email, 'email_verified', true),
    'email',
    v_user_id::text,
    v_now,
    v_now,
    v_now
  );

  insert into public.inverters (
    id,
    inverter_sn,
    profile,
    display_name,
    last_seen_at,
    created_at,
    location
  ) values (
    v_inverter_id,
    'SN-DEMO-0001',
    'growatt',
    'Home',
    v_now,
    v_start,
    '{"name":"London","latitude":51.5074,"longitude":-0.1278}'::jsonb
  );

  insert into public.inverter_members (
    inverter_id,
    user_id,
    role,
    created_at
  ) values (
    v_inverter_id,
    v_user_id,
    'owner',
    v_start
  );

  insert into public.gateways (
    id,
    hardware_id,
    inverter_id,
    status,
    provisioned_by,
    last_seen_at,
    firmware_version,
    created_at
  ) values (
    v_gateway_id,
    'GW-DEMO-0001',
    v_inverter_id,
    'active',
    v_user_id,
    v_now,
    '1.0.0-seed',
    v_start
  );

  -- 24h of snapshots at 5-minute intervals (289 points inclusive)
  insert into public.inverter_snapshots (
    inverter_id,
    gateway_id,
    recorded_at,
    ingested_at,
    battery_soc_percent,
    battery_voltage_v,
    battery_current_a,
    battery_charge_power_w,
    battery_discharge_power_w,
    battery_charge_energy_today_kwh,
    battery_discharge_energy_today_kwh,
    grid_active_power_w,
    grid_frequency_hz,
    grid_voltage_v,
    grid_current_a,
    grid_export_power_w,
    grid_export_energy_today_kwh,
    grid_import_energy_today_kwh,
    grid_charge_power_w,
    solar_energy_today_kwh,
    solar_power_w,
    home_load_power_w
  )
  with series as (
    select
      gs as recorded_at,
      extract(hour from gs at time zone 'UTC')::double precision
        + extract(minute from gs)::double precision / 60.0 as hour_frac
    from generate_series(v_start, v_now, interval '5 minutes') as gs
  ),
  metrics as (
    select
      recorded_at,
      hour_frac,
      greatest(
        0.0,
        5200.0 * greatest(0.0, sin(radians((hour_frac - 6.0) * 180.0 / 12.0)))
      ) as solar_power_w,
      650.0
        + 900.0 * case
          when hour_frac >= 7 and hour_frac < 10 then 1.0
          when hour_frac >= 17 and hour_frac < 22 then 1.2
          when hour_frac < 6 then 0.35
          else 0.7
        end
        + 80.0 * sin(radians(extract(minute from recorded_at)::double precision * 12.0))
        as home_load_power_w,
      greatest(
        15.0,
        least(
          98.0,
          55.0 + 25.0 * sin(radians((hour_frac - 6.0) * 15.0))
        )
      ) as battery_soc_percent
    from series
  ),
  powers as (
    select
      *,
      greatest(0.0, solar_power_w - home_load_power_w) as battery_charge_power_w,
      greatest(0.0, home_load_power_w - solar_power_w) as battery_discharge_power_w,
      greatest(0.0, solar_power_w - home_load_power_w - 500.0) as grid_export_power_w,
      greatest(0.0, home_load_power_w - solar_power_w - 800.0) as grid_import_power_w
    from metrics
  )
  select
    v_inverter_id,
    v_gateway_id,
    recorded_at,
    recorded_at + interval '2 seconds',
    battery_soc_percent,
    51.2 + 1.5 * sin(radians((hour_frac - 6.0) * 15.0)),
    case
      when battery_charge_power_w > 0 then battery_charge_power_w / 51.2
      else -battery_discharge_power_w / 51.2
    end,
    battery_charge_power_w,
    battery_discharge_power_w,
    round(
      (
        sum(battery_charge_power_w) over (
          partition by date_trunc('day', recorded_at)
          order by recorded_at
        ) / 12000.0
      )::numeric,
      3
    ),
    round(
      (
        sum(battery_discharge_power_w) over (
          partition by date_trunc('day', recorded_at)
          order by recorded_at
        ) / 12000.0
      )::numeric,
      3
    ),
    grid_import_power_w,
    50.0,
    230.0 + 2.0 * sin(radians(extract(minute from recorded_at)::double precision * 6.0)),
    (grid_import_power_w + grid_export_power_w) / 230.0,
    grid_export_power_w,
    round(
      (
        sum(grid_export_power_w) over (
          partition by date_trunc('day', recorded_at)
          order by recorded_at
        ) / 12000.0
      )::numeric,
      3
    ),
    round(
      (
        sum(grid_import_power_w) over (
          partition by date_trunc('day', recorded_at)
          order by recorded_at
        ) / 12000.0
      )::numeric,
      3
    ),
    0.0,
    round(
      (
        sum(solar_power_w) over (
          partition by date_trunc('day', recorded_at)
          order by recorded_at
        ) / 12000.0
      )::numeric,
      3
    ),
    solar_power_w,
    home_load_power_w
  from powers;

  -- Inverter 2: online / current snapshot (screenshot: multi-system list + live home)
  insert into public.inverters (
    id, inverter_sn, profile, display_name, last_seen_at, created_at, location
  ) values (
    v_inverter_id_2,
    'SN-DEMO-0002',
    'growatt',
    'Beach House',
    v_now,
    v_start,
    '{"name":"Brighton","latitude":50.8225,"longitude":-0.1372}'::jsonb
  );

  insert into public.inverter_members (inverter_id, user_id, role, created_at)
  values (v_inverter_id_2, v_user_id, 'owner', v_start);

  insert into public.gateways (
    id, hardware_id, inverter_id, status, provisioned_by,
    last_seen_at, firmware_version, created_at
  ) values (
    v_gateway_id_2, 'GW-DEMO-0002', v_inverter_id_2, 'active',
    v_user_id, v_now, '1.0.0-seed', v_start
  );

  insert into public.inverter_snapshots (
    inverter_id, gateway_id, recorded_at, ingested_at,
    battery_soc_percent, battery_voltage_v, battery_current_a,
    battery_charge_power_w, battery_discharge_power_w,
    battery_charge_energy_today_kwh, battery_discharge_energy_today_kwh,
    grid_active_power_w, grid_frequency_hz, grid_voltage_v, grid_current_a,
    grid_export_power_w, grid_export_energy_today_kwh, grid_import_energy_today_kwh,
    grid_charge_power_w, solar_energy_today_kwh, solar_power_w, home_load_power_w
  ) values (
    v_inverter_id_2, v_gateway_id_2, v_now, v_now + interval '2 seconds',
    72.0, 52.1, 8.5,
    450.0, 0.0,
    3.2, 0.4,
    0.0, 50.0, 231.0, 0.0,
    1200.0, 4.8, 0.2,
    0.0, 12.5, 2800.0, 1150.0
  );

  -- Inverter 3: stale / 1 day prior (screenshot: offline / last updated yesterday)
  insert into public.inverters (
    id, inverter_sn, profile, display_name, last_seen_at, created_at, location
  ) values (
    v_inverter_id_3,
    'SN-DEMO-0003',
    'growatt',
    'Workshop',
    v_yesterday,
    v_start,
    '{"name":"Manchester","latitude":53.4808,"longitude":-2.2426}'::jsonb
  );

  insert into public.inverter_members (inverter_id, user_id, role, created_at)
  values (v_inverter_id_3, v_user_id, 'owner', v_start);

  insert into public.gateways (
    id, hardware_id, inverter_id, status, provisioned_by,
    last_seen_at, firmware_version, created_at
  ) values (
    v_gateway_id_3, 'GW-DEMO-0003', v_inverter_id_3, 'active',
    v_user_id, v_yesterday, '1.0.0-seed', v_start
  );

  insert into public.inverter_snapshots (
    inverter_id, gateway_id, recorded_at, ingested_at,
    battery_soc_percent, battery_voltage_v, battery_current_a,
    battery_charge_power_w, battery_discharge_power_w,
    battery_charge_energy_today_kwh, battery_discharge_energy_today_kwh,
    grid_active_power_w, grid_frequency_hz, grid_voltage_v, grid_current_a,
    grid_export_power_w, grid_export_energy_today_kwh, grid_import_energy_today_kwh,
    grid_charge_power_w, solar_energy_today_kwh, solar_power_w, home_load_power_w
  ) values (
    v_inverter_id_3, v_gateway_id_3, v_yesterday, v_yesterday + interval '2 seconds',
    38.0, 50.4, -12.0,
    0.0, 620.0,
    1.1, 2.8,
    450.0, 50.0, 229.0, 2.0,
    0.0, 0.6, 3.4,
    0.0, 6.1, 0.0, 980.0
  );
end $$;
