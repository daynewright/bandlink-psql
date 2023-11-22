CREATE OR REPLACE FUNCTION get_user_single_conversations(
    p_user_id uuid
) RETURNS TABLE (
    conversation_id uuid,
    other_user_id uuid,
    other_user_name character varying,
    other_user_profile_pic character varying,
    last_message text,
    last_message_date timestamp with time zone
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id AS conversation_id,
        ou.id AS other_user_id,
        ou.first_name || ' ' || ou.last_name AS other_user_name,
        ou.profile_image_id AS other_user_profile_pic,
        m.context AS last_message,
        m.created_at AS last_message_date
    FROM
        public.conversations c
    JOIN
        public.users_conversation uc ON c.id = uc.conversation_id AND uc.user_id = p_user_id
    JOIN
        public.users_profile ou ON c.id = ou.id AND ou.id <> p_user_id
    LEFT JOIN
        public.messages m ON c.id = m.conversation_id
    LEFT JOIN LATERAL (
        SELECT
            context AS last_message,
            created_at AS last_message_date
        FROM
            public.messages
        WHERE
            conversation_id = c.id
        ORDER BY
            created_at DESC
        LIMIT 1
    ) lm ON true
    ORDER BY
        last_message_date DESC;

END;
$$ LANGUAGE plpgsql;
