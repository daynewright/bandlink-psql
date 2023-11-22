create table
  public.event_attendance (
    created_at timestamp with time zone not null default now(),
    status public.attendence_status not null default 'ATTENDING'::attendence_status,
    event_id uuid not null,
    user_id uuid not null,
    constraint event_attendance_pkey primary key (event_id, user_id),
    constraint event_attendance_event_id_fkey foreign key (event_id) references events (id) on update cascade on delete cascade,
    constraint event_attendance_user_id_fkey foreign key (user_id) references users_profile (id) on update cascade on delete cascade
  ) tablespace pg_default;