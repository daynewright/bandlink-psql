CREATE OR REPLACE FUNCTION get_conversations_for_event(p_event_id uuid)
RETURNS TABLE (
    conversation_id uuid,
    event_id uuid,
    message text,
    sender_user_id uuid,
    sender_name text,
    sender_image_path text,
    file_name text,
    file_path text,
    image_name text,
    image_path text,
    created_at timestamp with time zone
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id AS conversation_id,
        c.event_id,
        m.context AS message,
        m.user_id AS sender_user_id,
        COALESCE(up.first_name || ' ' || up.last_name, 'Unknown') AS sender_name,
        CASE
            WHEN i.image_path IS NOT NULL THEN i.image_path
            ELSE NULL
        END AS sender_image_path,
        f.file_name,
        f.file_path,
        img.image_name,
        img.image_path,
        m.created_at AS timestamp
    FROM
        public.conversations c
    JOIN
        public.messages m ON c.id = m.conversation_id
    LEFT JOIN
        public.users_profile up ON m.user_id = up.id
    LEFT JOIN
        public.images i ON up.profile_image_id = i.id
    LEFT JOIN
        public.message_attachments ma ON m.id = ma.message_id
    LEFT JOIN
        public.files f ON ma.file_id = f.id
    LEFT JOIN
        public.images img ON ma.image_id = img.id
    WHERE
        c.event_id = p_event_id
        AND c.conversation_type = 'EVENT'
    ORDER BY
        m.created_at;

END;
$$ LANGUAGE plpgsql;