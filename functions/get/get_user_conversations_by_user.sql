CREATE OR REPLACE FUNCTION get_user_conversations_by_user(
    p_user_id uuid
)
RETURNS TABLE (
    conversation_id uuid,
    other_user_id uuid,
    other_user_name text,
    other_user_image_path text,
    recent_message_text text,
    recent_message_created_at timestamp with time zone
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id AS conversation_id,
        CASE
            WHEN c.user_id_a = p_user_id THEN c.user_id_b
            ELSE c.user_id_a
        END AS other_user_id,
        COALESCE(up.first_name || ' ' || up.last_name, 'Unknown') AS other_user_name,
        CASE
            WHEN i.image_path IS NOT NULL THEN i.image_path
            ELSE NULL
        END AS other_user_image_path,
        m.context AS recent_message_text,
        MAX(m.created_at) AS recent_message_created_at
    FROM
        public.conversations c
    LEFT JOIN
        public.users_profile up ON up.id = CASE WHEN c.user_id_a = p_user_id THEN c.user_id_b ELSE c.user_id_a END
    LEFT JOIN
        public.images i ON up.profile_image_id = i.id
    LEFT JOIN
        public.messages m ON c.id = m.conversation_id
    WHERE
        c.conversation_type = 'USER'
        AND (c.user_id_a = p_user_id OR c.user_id_b = p_user_id)
    GROUP BY
        c.id, other_user_id, other_user_name, other_user_image_path, recent_message_text
    ORDER BY
        recent_message_created_at DESC;

END;
$$ LANGUAGE plpgsql;
