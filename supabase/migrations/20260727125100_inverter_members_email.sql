-- Store member email on inverter_members for display in the app.
-- Populated on insert from auth.users and kept in sync on email change.

alter table public.inverter_members
  add column email text;

update public.inverter_members im
set email = u.email
from auth.users u
where im.user_id = u.id;

alter table public.inverter_members
  alter column email set not null;

create or replace function public.set_inverter_member_email()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.email is null then
    select u.email
    into new.email
    from auth.users u
    where u.id = new.user_id;

    if new.email is null then
      raise exception 'user % has no email', new.user_id;
    end if;
  end if;

  return new;
end;
$$;

create trigger set_inverter_member_email_before_insert
  before insert on public.inverter_members
  for each row
  execute function public.set_inverter_member_email();

create or replace function public.sync_inverter_member_email()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.email is distinct from old.email then
    update public.inverter_members
    set email = new.email
    where user_id = new.id;
  end if;

  return new;
end;
$$;

create trigger on_auth_user_email_updated
  after update of email on auth.users
  for each row
  execute function public.sync_inverter_member_email();

revoke all on function public.set_inverter_member_email() from public;
revoke all on function public.sync_inverter_member_email() from public;
