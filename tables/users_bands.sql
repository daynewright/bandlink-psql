create table
  public.users_bands (
    created_at timestamp with time zone not null default now(),
    user_id uuid not null,
    band_id uuid not null,
    constraint users_bands_pkey primary key (user_id, band_id),
    constraint users_bands_band_id_fkey foreign key (band_id) references bands (id) on update cascade on delete cascade,
    constraint users_bands_user_id_fkey foreign key (user_id) references users_profile (id) on update cascade on delete cascade
  ) tablespace pg_default;