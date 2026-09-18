-- DSGVO: authentifizierte Nutzer dürfen ihr Konto und zugehörige Daten löschen.
create or replace function public.delete_user_account()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
begin
  if uid is null then
    raise exception 'Not authenticated';
  end if;

  delete from public.matches where user_id = uid;
  delete from public.tournaments where user_id = uid;
  delete from public.decks where user_id = uid;

  delete from auth.users where id = uid;
end;
$$;

revoke all on function public.delete_user_account() from public;
grant execute on function public.delete_user_account() to authenticated;
