-- Raw Modbus dumps from firmware MODBUS_DEBUG uploads.
alter table public.inverter_snapshots
  add column if not exists metadata jsonb;

comment on column public.inverter_snapshots.metadata is
  'Optional debug payload (e.g. full FC04 register dump when MODBUS_DEBUG is enabled).';
