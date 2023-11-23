
BEGIN
    RETURN QUERY
    SELECT
        c.id AS conversation_id,
        c.group_id,
        g.group_name,
        COUNT(DISTINCT up.id) AS user_count,
        MAX(m.created_at) AS recent_message_created_at
    FROM
        public.conversations c
    JOIN
        public.groups g ON c.group_id = g.id
    LEFT JOIN
        public.users_profile up ON up.id = p_user_id
    LEFT JOIN
        public.messages m ON c.id = m.conversation_id
    WHERE
        c.conversation_type = 'GROUP'
    GROUP BY
        c.id, g.id
    ORDER BY
        recent_message_created_at DESC;

END;