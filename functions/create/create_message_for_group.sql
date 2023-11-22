CREATE OR REPLACE FUNCTION create_message_for_group(
    p_group_id uuid,
    p_user_id uuid,
    p_message_text text,
    p_file_id uuid DEFAULT NULL,
    p_image_id uuid DEFAULT NULL
)
RETURNS VOID AS $$
DECLARE
    v_message_id uuid;
    v_conversation_id uuid;
BEGIN
    -- Check if a conversation exists for the group
    SELECT id INTO v_conversation_id
    FROM public.conversations
    WHERE group_id = p_group_id;

    -- If a conversation doesn't exist, create one
    IF v_conversation_id IS NULL THEN
        INSERT INTO public.conversations (group_id)
        VALUES (p_group_id)
        RETURNING id INTO v_conversation_id;
    END IF;

    -- Insert the message
    INSERT INTO public.messages (conversation_id, user_id, context)
    VALUES (v_conversation_id, p_user_id, p_message_text)
    RETURNING id INTO v_message_id;

    -- Insert attachments if provided
    IF p_file_id IS NOT NULL OR p_image_id IS NOT NULL THEN
        INSERT INTO public.message_attachments (message_id, file_id, image_id)
        VALUES (v_message_id, p_file_id, p_image_id);
    END IF;
END;
$$ LANGUAGE plpgsql;
