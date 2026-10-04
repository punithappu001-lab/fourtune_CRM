-- Run once in Supabase: SQL Editor > New query > paste > Run
create table public.records(
  coll text not null, id text not null,
  data jsonb not null default '{}',
  actor text default (auth.jwt()->>'email'),
  updated_at timestamptz default now(),
  primary key (coll,id));
alter table public.records enable row level security;
create policy r_sel on public.records for select to authenticated using (true);
create policy r_ins on public.records for insert to authenticated with check (true);
-- Activity log rows (coll = 'logs') can be added and read, never edited or deleted:
create policy r_upd on public.records for update to authenticated using (coll<>'logs') with check (coll<>'logs');
create policy r_del on public.records for delete to authenticated using (coll<>'logs');
alter table public.records replica identity full;
alter publication supabase_realtime add table public.records;
