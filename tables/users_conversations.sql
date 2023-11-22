create table
  public.users_conversation (
    created_at timestamp with time zone not null default now(),
    id uuid not null default gen_random_uuid (),
    band_id uuid null,
    group_id uuid null,
    event_id uuid null,
    conversation_id uuid not null,
    user_id uuid not null,
    constraint user_conversation_pkey primary key (user_id, conversation_id),
    constraint users_conversation_band_id_fkey foreign key (band_id) references bands (id) on update cascade on delete cascade,
    constraint users_conversation_conversation_id_fkey foreign key (conversation_id) references conversations (id) on update cascade on delete cascade,
    constraint users_conversation_event_id_fkey foreign key (event_id) references events (id) on update cascade on delete cascade,
    constraint users_conversation_group_id_fkey foreign key (group_id) references groups (id) on update cascade on delete cascade,
    constraint users_conversation_user_id_fkey foreign key (user_id) references users_profile (id) on update cascade on delete cascade
  ) tablespace pg_default;