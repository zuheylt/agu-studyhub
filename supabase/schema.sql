-- AGU StudyHub — starter schema (see docs/requirements.md, section D)
-- Hierarchy: department -> course -> week -> material

create type sharing_mode as enum ('full', 'agu_only', 'syllabus_only');
create type material_visibility as enum ('public', 'agu_only', 'hidden');
create type material_section as enum ('instructor', 'lab', 'oer');
create type material_type as enum ('slides', 'video', 'syllabus', 'reading', 'lab_explanation', 'oer', 'simulation', 'other');

create table department (
  id    bigint generated always as identity primary key,
  name  text not null unique
);

create table course (
  id             bigint generated always as identity primary key,
  department_id  bigint not null references department(id) on delete restrict,
  code           text not null unique,          -- e.g. 'PHYS 101'
  title          text not null,
  instructor     text,
  description    text,
  has_lab        boolean not null default false, -- FR-3: lab section only when true
  sharing_mode   sharing_mode not null default 'syllabus_only', -- FR-5, FR-6
  published      boolean not null default false,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);

create table week (
  id                   bigint generated always as identity primary key,
  course_id            bigint not null references course(id) on delete cascade,
  week_number          int not null check (week_number between 1 and 16),
  topic                text not null,
  subtopics            text[] not null default '{}',
  learning_objectives  text[] not null default '{}',
  position             int not null default 0,   -- FR-8: reordering
  unique (course_id, week_number)
);

create table material (
  id               bigint generated always as identity primary key,
  week_id          bigint not null references week(id) on delete cascade,
  title            text not null,
  type             material_type not null,
  section          material_section not null,
  url              text,                         -- external link / embed (FR-7)
  storage_path     text,                         -- file in Supabase Storage
  source           text not null,                -- FR-4
  licence_note     text not null,                -- licence or instructor permission note
  visibility       material_visibility not null default 'hidden', -- FR-9
  position         int not null default 0,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  check (url is not null or storage_path is not null)
);

-- Team members who can use the admin interface (FR-8)
create table admin_user (
  user_id  uuid primary key references auth.users(id) on delete cascade
);

create index on course (department_id);
create index on week (course_id);
create index on material (week_id);

-- Row Level Security (NFR-3): anonymous users only see public material of
-- published courses; signed-in @agu.edu.tr users also see agu_only; admins see all.
alter table department enable row level security;
alter table course     enable row level security;
alter table week       enable row level security;
alter table material   enable row level security;
alter table admin_user enable row level security;

create or replace function is_agu_user() returns boolean language sql stable as $$
  select coalesce((auth.jwt() ->> 'email') like '%@agu.edu.tr', false)
$$;

create or replace function is_admin() returns boolean language sql stable security definer as $$
  select exists (select 1 from admin_user where user_id = auth.uid())
$$;

create policy "read departments" on department for select using (true);
create policy "read published courses" on course for select using (published or is_admin());
create policy "read weeks of published courses" on week for select
  using (exists (select 1 from course c where c.id = course_id and (c.published or is_admin())));
create policy "read visible materials" on material for select using (
  is_admin()
  or exists (
    select 1 from week w join course c on c.id = w.course_id
    where w.id = week_id and c.published and c.sharing_mode <> 'syllabus_only'
      and (
        (visibility = 'public' and c.sharing_mode = 'full')
        or (visibility in ('public', 'agu_only') and is_agu_user())
      )
  )
);

create policy "admins write departments" on department for all using (is_admin()) with check (is_admin());
create policy "admins write courses"     on course     for all using (is_admin()) with check (is_admin());
create policy "admins write weeks"       on week       for all using (is_admin()) with check (is_admin());
create policy "admins write materials"   on material   for all using (is_admin()) with check (is_admin());
create policy "admins read admins"       on admin_user for select using (is_admin());
