-- Break remaining RLS recursion for viewers.
-- is_inverter_member / is_inverter_owner are SECURITY INVOKER and query
-- inverter_members, whose select_owner policy calls is_inverter_owner again.
-- Owners often terminate via select_self; viewers re-enter until stack overflow.
-- SECURITY DEFINER (plpgsql, non-inlinable) bypasses RLS on the membership
-- lookup while still authorizing via auth.uid().

create or replace function public.is_inverter_member(p_inverter_id uuid)
returns boolean
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  return exists (
    select 1
    from public.inverter_members
    where inverter_id = p_inverter_id
      and user_id = auth.uid()
  );
end;
$$;

create or replace function public.is_inverter_owner(p_inverter_id uuid)
returns boolean
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  return exists (
    select 1
    from public.inverter_members
    where inverter_id = p_inverter_id
      and user_id = auth.uid()
      and role = 'owner'
  );
end;
$$;

revoke all on function public.is_inverter_member(uuid) from public;
revoke all on function public.is_inverter_owner(uuid) from public;

grant execute on function public.is_inverter_member(uuid) to authenticated;
grant execute on function public.is_inverter_owner(uuid) to authenticated;

revoke execute on function public.is_inverter_member(uuid) from anon;
revoke execute on function public.is_inverter_owner(uuid) from anon;
