create table
  public.files (
    created_at timestamp with time zone not null default now(),
    file_name text not null,
    file_path text not null,
    id uuid not null default gen_random_uuid (),
    constraint Files_pkey primary key (id)
  ) tablespace pg_default;