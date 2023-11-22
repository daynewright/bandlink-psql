CREATE OR REPLACE FUNCTION get_messages_for_conversation_group(
    p_user_id uuid,
    p_group_id uuid,
    p_page_number int,
    p_items_per_page int
) RETURNS TABLE (
    message_id uuid,
    user_id uuid,
    user_name character varying,
    user_profile_pic character varying,
    message_text text,
    image_id uuid,
    image_path character varying,
    created_at timestamp with time zone,
    is_sender boolean,
    is_read boolean
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.id AS message_id,
        up.id AS user_id,
        up.first_name || ' ' || up.last_name AS user_name,
        up.profile_image_id AS user_profile_pic,
        m.context AS message_text,
        ma.image_id,
        i.image_path,
        m.created_at,
        (m.user_id = p_user_id) AS is_sender,
        COALESCE(mrs.is_read, false) AS is_read
    FROM
        public.messages m
    JOIN
        public.users_profile up ON m.user_id = up.id
    LEFT JOIN
        public.message_attachments ma ON m.id = ma.message_id
    LEFT JOIN
        public.images i ON ma.image_id = i.id
    LEFT JOIN
        public.users_conversation uc ON m.conversation_id = uc.conversation_id
    LEFT JOIN
        public.message_read_status mrs ON m.id = mrs.message_id AND mrs.user_id = p_user_id
    WHERE
        uc.user_id = p_user_id
        AND uc.group_id = p_group_id
    ORDER BY
        m.created_at DESC
    OFFSET
        (p_page_number - 1) * p_items_per_page
    LIMIT
        p_items_per_page;

END;
$$ LANGUAGE plpgsql;