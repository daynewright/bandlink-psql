create table
  public.users_profile (
    id uuid not null default gen_random_uuid (),
    auth_user_id uuid null,
    email character varying null,
    phone text null,
    profile_image_id uuid null,
    status public.user_status not null default 'ACTIVE'::user_status,
    first_name text null,
    last_name text null,
    is_child boolean not null default false,
    child_id uuid null,
    created_at timestamp with time zone null default now(),
    about text null,
    instruments text[] null,
    title text null,
    constraint users_profile_pkey primary key (id),
    constraint users_profile_auth_user_id_fkey foreign key (auth_user_id) references auth.users (id),
    constraint users_profile_child_id_fkey foreign key (child_id) references users_profile (id) on update cascade on delete set null,
    constraint users_profile_profile_image_id_fkey foreign key (profile_image_id) references images (id) on update cascade on delete cascade
  ) tablespace pg_default;