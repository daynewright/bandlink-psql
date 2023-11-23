CREATE OR REPLACE FUNCTION get_messages_by_conversation_group(
    p_group_id uuid,
    p_page_size integer,
    p_page_number integer
)
RETURNS TABLE (
    message_id uuid,
    sender_user_id uuid,
    sender_name text,
    sender_image_path text,
    context text,
    file_name text,
    file_path text,
    image_name text,
    image_path text,
    created_at timestamp with time zone
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.id AS message_id,
        m.user_id AS sender_user_id,
        COALESCE(up.first_name || ' ' || up.last_name, 'Unknown') AS sender_name,
        CASE
            WHEN img.image_path IS NOT NULL THEN img.image_path
            ELSE NULL
        END AS sender_image_path,
        m.context,
        f.file_name,
        f.file_path,
        img.image_name,
        img.image_path,
        m.created_at
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
        c.group_id = p_group_id
        AND c.conversation_type = 'GROUP'
    ORDER BY
        m.created_at DESC
    LIMIT
        p_page_size
    OFFSET
        (p_page_number - 1) * p_page_size;

END;
$$ LANGUAGE plpgsql;