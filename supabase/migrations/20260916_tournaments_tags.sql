alter table public.tournaments
  add column if not exists tags text[] not null default '{}';
