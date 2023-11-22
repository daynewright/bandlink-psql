create table
  public.events_images (
    created_at timestamp with time zone not null default now(),
    event_id uuid not null,
    image_id uuid not null,
    constraint events_images_pkey primary key (event_id, image_id),
    constraint events_images_event_id_fkey foreign key (event_id) references events (id) on update cascade on delete cascade,
    constraint events_images_image_id_fkey foreign key (image_id) references images (id) on update cascade on delete cascade
  ) tablespace pg_default;