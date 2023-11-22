create table
  public.images (
    created_at timestamp with time zone not null default now(),
    image_name text null,
    image_path text not null,
    id uuid not null default gen_random_uuid (),
    constraint Images_pkey primary key (id)
  ) tablespace pg_default;