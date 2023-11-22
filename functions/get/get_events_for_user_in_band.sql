CREATE OR REPLACE FUNCTION get_events_for_user_in_band(
    p_user_id uuid,
    p_band_id uuid,
    p_page_number int,
    p_items_per_page int,
    p_sort_order text
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
    conversation_count bigint,
    group_names text[]  -- Change here
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
        i.image_path AS creator_picture,
        COUNT(DISTINCT ea.user_id) AS attendees_count,
        COUNT(DISTINCT c.id) AS conversation_count,
        ARRAY_AGG(DISTINCT g.group_name)::text[] AS group_names  -- Change here
    FROM
        public.events e
    LEFT JOIN
        public.event_attendance ea ON e.id = ea.event_id AND ea.user_id = p_user_id
    LEFT JOIN
        public.users_profile up ON e.creator_user_id = up.id
    LEFT JOIN
        public.images i ON up.profile_image_id = i.id
    LEFT JOIN
        public.conversations c ON e.id = c.event_id
    LEFT JOIN
        public.events_groups eg ON e.id = eg.event_id
    LEFT JOIN
        public.groups g ON eg.group_id = g.id
    WHERE
        e.band_id = p_band_id
    GROUP BY
        e.id, up.id, c.id, i.id
    ORDER BY
        CASE
            WHEN p_sort_order = 'asc' THEN
                e.event_date
            ELSE
                NULL
        END,
        CASE
            WHEN p_sort_order = 'desc' THEN
                e.event_date
            ELSE
                NULL
        END DESC
    OFFSET
        (p_page_number - 1) * p_items_per_page
    LIMIT
        p_items_per_page;
END;
$$ LANGUAGE plpgsql;