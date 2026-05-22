create or replace function public.revoke_invite(p_invite_id uuid)
returns boolean
language sql
security invoker
set search_path = public
stable as $$
  update public.inverter_invites
  set revoked_at = now()
  where id = p_invite_id
    and public.is_inverter_owner(inverter_id)
  returning true;
$$;