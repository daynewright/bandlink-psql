create table
  public.events_groups (
    created_at timestamp with time zone not null default now(),
    event_id uuid not null,
    group_id uuid not null,
    constraint events_groups_pkey primary key (event_id, group_id),
    constraint events_groups_event_id_fkey foreign key (event_id) references events (id) on update cascade on delete cascade,
    constraint events_groups_group_id_fkey foreign key (group_id) references groups (id) on update cascade on delete cascade
  ) tablespace pg_default;