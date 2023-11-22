create table
  public.message_read_status (
    user_id uuid not null,
    message_id uuid not null,
    is_read boolean null default false,
    constraint message_read_status_pkey primary key (user_id, message_id),
    constraint message_read_status_message_id_fkey foreign key (message_id) references messages (id) on update cascade on delete cascade,
    constraint message_read_status_user_id_fkey foreign key (user_id) references users_profile (id) on update cascade on delete cascade
  ) tablespace pg_default;