CREATE OR REPLACE FUNCTION get_messages_by_conversations_user(
    p_logged_in_user_id uuid,
    p_other_user_id uuid,
    p_page_size integer,
    p_page_number integer
)
RETURNS TABLE (
    message_id uuid,
    other_user_id uuid,
    other_user_name text,
    other_user_image_path text,
    context text,
    file_name text,
    file_path text,
    image_name text,
    image_path text,
    created_at timestamp with time zone,
    is_from_logged_in_user boolean -- Retained this column
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.id AS message_id,
        CASE
            WHEN c.user_id_a = p_logged_in_user_id THEN c.user_id_b
            ELSE c.user_id_a
        END AS other_user_id,
        COALESCE(up.first_name || ' ' || up.last_name, 'Unknown') AS other_user_name,
        CASE
            WHEN img.image_path IS NOT NULL THEN img.image_path
            ELSE NULL
        END AS other_user_image_path,
        m.context,
        f.file_name,
        f.file_path,
        img.image_name,
        img.image_path,
        m.created_at,
        m.user_id = p_logged_in_user_id AS is_from_logged_in_user
    FROM
        public.messages m
    JOIN
        public.users_profile up ON m.user_id = up.id
    LEFT JOIN
        public.message_attachments ma ON m.id = ma.message_id
    LEFT JOIN
        public.files f ON ma.file_id = f.id
    LEFT JOIN
        public.images img ON ma.image_id = img.id
    JOIN
        public.conversations c ON m.conversation_id = c.id
    WHERE
        (c.user_id_a = p_logged_in_user_id AND c.user_id_b = p_other_user_id)
        OR (c.user_id_a = p_other_user_id AND c.user_id_b = p_logged_in_user_id)
        AND c.conversation_type = 'USER'
    ORDER BY
        m.created_at DESC
    LIMIT
        p_page_size
    OFFSET
        (p_page_number - 1) * p_page_size;

END;
$$ LANGUAGE plpgsql;
