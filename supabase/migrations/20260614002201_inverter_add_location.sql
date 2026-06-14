alter table public.inverters
	add column location jsonb not null default '{}'::jsonb;
