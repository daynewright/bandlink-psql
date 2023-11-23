create table
  public.conversations (
    created_at timestamp with time zone not null default now(),
    id uuid not null default gen_random_uuid (),
    band_id uuid null,
    event_id uuid null,
    group_id uuid null,
    user_id_a uuid null,
    user_id_b uuid null,
    conversation_type public.conversation_type not null,
    constraint Conversations_pkey primary key (id),
    constraint conversations_band_id_fkey foreign key (band_id) references bands (id),
    constraint conversations_event_id_fkey foreign key (event_id) references events (id),
    constraint conversations_group_id_fkey foreign key (group_id) references groups (id),
    constraint conversations_user_id_a_fkey foreign key (user_id_a) references users_profile (id),
    constraint conversations_user_id_b_fkey foreign key (user_id_b) references users_profile (id)
  ) tablespace pg_default;