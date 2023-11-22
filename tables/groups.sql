create table
  public.groups (
    created_at timestamp with time zone not null default now(),
    group_name text not null,
    id uuid not null default gen_random_uuid (),
    band_id uuid not null,
    constraint Groups_pkey primary key (id),
    constraint Groups_group_name_key unique (group_name),
    constraint groups_band_id_fkey foreign key (band_id) references bands (id) on update cascade on delete cascade
  ) tablespace pg_default;