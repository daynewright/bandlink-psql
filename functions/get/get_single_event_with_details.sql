CREATE OR REPLACE FUNCTION get_single_event_with_details(
    p_event_id uuid
) RETURNS TABLE (
    event_id uuid,
    event_name character varying,
    description text,
    event_date timestamp with time zone,
    start_time time with time zone,
    end_time time with time zone,
    creator_user_id uuid,
    creator_name character varying,
    creator_picture character varying,
    attendees_count bigint,
    files jsonb[],
    images jsonb[]
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.id AS event_id,
        e.event_name,
        e.description,
        e.event_date,
        e.start_time,
        e.end_time,
        e.creator_user_id,
        up.first_name || ' ' || up.last_name AS creator_name,
        up.profile_image_id AS creator_picture,
        COUNT(DISTINCT ea.user_id) AS attendees_count,
        ARRAY_AGG(DISTINCT f.file_path) AS files,
        ARRAY_AGG(DISTINCT i.image_path) AS images
    FROM
        public.events e
    LEFT JOIN
        public.event_attendance ea ON e.id = ea.event_id
    LEFT JOIN
        public.users_profile up ON e.creator_user_id = up.id
    LEFT JOIN
        public.events_files ef ON e.id = ef.event_id
    LEFT JOIN
        public.files f ON ef.file_id = f.id
    LEFT JOIN
        public.events_images ei ON e.id = ei.event_id
    LEFT JOIN
        public.images i ON ei.image_id = i.id
    WHERE
        e.id = p_event_id
    GROUP BY
        e.id, up.id;

END;
$$ LANGUAGE plpgsql;