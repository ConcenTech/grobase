-- Ensure all existing inverters have a display_name
update public.inverters
    set display_name = inverter_sn
    where display_name is null;

-- Make display_name not null
alter table public.inverters
    alter column display_name set not null;