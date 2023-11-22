create table
  public.messages (
    created_at timestamp with time zone not null default now(),
    context text not null,
    id uuid not null default gen_random_uuid (),
    conversation_id uuid null,
    user_id uuid not null,
    constraint Messages_pkey primary key (id),
    constraint messages_conversation_id_fkey foreign key (conversation_id) references conversations (id) on update cascade on delete cascade,
    constraint messages_user_id_fkey foreign key (user_id) references users_profile (id) on update cascade on delete cascade
  ) tablespace pg_default;