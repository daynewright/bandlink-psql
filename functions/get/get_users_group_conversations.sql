CREATE OR REPLACE FUNCTION get_user_group_conversations(
    p_user_id uuid
) RETURNS TABLE (
    conversation_id uuid,
    group_id uuid,
    group_name character varying,
    user_count bigint,
    last_message_date timestamp with time zone
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id AS conversation_id,
        g.id AS group_id,
        g.group_name,
        COUNT(DISTINCT up.id) AS user_count,
        MAX(m.created_at) AS last_message_date
    FROM
        public.conversations c
    INNER JOIN
        public.users_conversation uc ON c.id = uc.conversation_id AND uc.user_id = p_user_id
    LEFT JOIN
        public.users_profile up ON uc.user_id = up.id
    LEFT JOIN
        public.groups g ON c.group_id = g.id
    LEFT JOIN
        public.messages m ON c.id = m.conversation_id
    GROUP BY
        c.id, g.id
    ORDER BY
        user_count DESC, last_message_date DESC;

END;
$$ LANGUAGE plpgsql;
