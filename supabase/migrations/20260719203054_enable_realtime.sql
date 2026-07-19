-- Enable Supabase Realtime postgres_changes for tables the app subscribes to.
-- Without this, INSERT/UPDATE/DELETE never reach RealtimeChannel listeners
-- (SyncService → Drift → UI), so the app only updates on cold sync/reconnect.
do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'inverter_snapshots'
  ) then
    alter publication supabase_realtime add table public.inverter_snapshots;
  end if;
  
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'inverters'
  ) then
    alter publication supabase_realtime add table public.inverters;
  end if;
end $$;
