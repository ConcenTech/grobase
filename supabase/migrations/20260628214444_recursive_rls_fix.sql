-- Break RLS recursion between inverters and inverter_members.
-- is_inverter_member/is_inverter_owner query inverter_members, but the only
-- SELECT policy there called is_inverter_owner again, causing stack overflow.
-- Allow users to read their own membership row without invoking owner checks.
create policy inverter_members_select_self
  on public.inverter_members
  for select
  to authenticated
  using (user_id = auth.uid());
