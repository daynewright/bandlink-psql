CREATE OR REPLACE FUNCTION create_message_for_event(
    p_event_id uuid,
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
    -- Check if a conversation exists for the event
    SELECT id INTO v_conversation_id
    FROM public.conversations
    WHERE event_id = p_event_id;

    -- If a conversation doesn't exist, create one
    IF v_conversation_id IS NULL THEN
        INSERT INTO public.conversations (event_id, conversation_type)
        VALUES (p_event_id, 'EVENT')
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
