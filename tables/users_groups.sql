create table
  public.users_groups (
    created_at timestamp with time zone not null default now(),
    group_id uuid not null,
    user_id uuid not null,
    constraint users_groups_pkey primary key (group_id, user_id),
    constraint users_groups_group_id_fkey foreign key (group_id) references groups (id) on update cascade on delete cascade,
    constraint users_groups_user_id_fkey foreign key (user_id) references users_profile (id) on update cascade on delete cascade
  ) tablespace pg_default;