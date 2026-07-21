-- Rename site grid import column for clarity (was Pac; now Pactouser).
alter table public.inverter_snapshots
  rename column grid_active_power_w to grid_import_power_w;
