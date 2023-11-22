create table
  public.message_attachments (
    created_at timestamp with time zone not null default now(),
    id uuid not null default gen_random_uuid (),
    file_id uuid null,
    image_id uuid null,
    message_id uuid not null,
    constraint Message_Attachments_pkey primary key (id),
    constraint message_attachments_file_id_fkey foreign key (file_id) references files (id) on update cascade on delete cascade,
    constraint message_attachments_image_id_fkey foreign key (image_id) references images (id) on update cascade on delete cascade,
    constraint message_attachments_message_id_fkey foreign key (message_id) references messages (id) on update cascade on delete cascade
  ) tablespace pg_default;