create table
  public.events_files (
    created_at timestamp with time zone not null default now(),
    event_id uuid not null,
    file_id uuid not null,
    constraint events_files_pkey primary key (event_id, file_id),
    constraint events_files_event_id_fkey foreign key (event_id) references events (id) on update cascade on delete cascade,
    constraint events_files_file_id_fkey foreign key (file_id) references files (id) on update cascade on delete cascade
  ) tablespace pg_default;