create table
  public.events (
    created_at timestamp with time zone not null default now(),
    event_name text not null,
    description text null,
    event_date timestamp with time zone null,
    start_time time with time zone null,
    end_time time with time zone null,
    id uuid not null default gen_random_uuid (),
    band_id uuid not null,
    creator_user_id uuid not null,
    owner_user_id uuid null,
    constraint Events_pkey primary key (id),
    constraint events_band_id_fkey foreign key (band_id) references bands (id) on update cascade on delete cascade,
    constraint events_creator_user_id_fkey foreign key (creator_user_id) references users_profile (id) on update cascade on delete cascade,
    constraint events_owner_user_id_fkey foreign key (owner_user_id) references users_profile (id) on update cascade on delete set null
  ) tablespace pg_default;