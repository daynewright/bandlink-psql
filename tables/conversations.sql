create table
  public.conversations (
    created_at timestamp with time zone not null default now(),
    id uuid not null default gen_random_uuid (),
    band_id uuid null,
    event_id uuid null,
    group_id uuid null,
    constraint Conversations_pkey primary key (id),
    constraint conversations_band_id_fkey foreign key (band_id) references bands (id) on update cascade on delete cascade,
    constraint conversations_event_id_fkey foreign key (event_id) references events (id) on update cascade on delete cascade,
    constraint conversations_group_id_fkey foreign key (group_id) references groups (id) on update cascade on delete cascade
  ) tablespace pg_default;