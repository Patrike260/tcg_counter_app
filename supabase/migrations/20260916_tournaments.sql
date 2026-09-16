-- Turniere & Events
create table if not exists public.tournaments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  game_id uuid not null references public.games (id),
  deck_id uuid references public.decks (id) on delete set null,
  name text not null,
  tournament_date date not null default current_date,
  placement integer,
  total_participants integer,
  notes text,
  tags text[] not null default '{}',
  created_at timestamptz not null default now()
);

create index if not exists tournaments_user_date_idx
  on public.tournaments (user_id, tournament_date desc);

alter table public.tournaments enable row level security;

drop policy if exists "Users can view own tournaments" on public.tournaments;
create policy "Users can view own tournaments"
  on public.tournaments for select
  using (auth.uid() = user_id);

drop policy if exists "Users can insert own tournaments" on public.tournaments;
create policy "Users can insert own tournaments"
  on public.tournaments for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update own tournaments" on public.tournaments;
create policy "Users can update own tournaments"
  on public.tournaments for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete own tournaments" on public.tournaments;
create policy "Users can delete own tournaments"
  on public.tournaments for delete
  using (auth.uid() = user_id);
