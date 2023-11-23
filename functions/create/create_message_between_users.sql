CREATE OR REPLACE FUNCTION create_message_between_users(
    p_sender_id uuid,
    p_receiver_id uuid,
    p_message_text text,
    p_file_id uuid DEFAULT NULL,
    p_image_id uuid DEFAULT NULL
)
RETURNS VOID AS $$
DECLARE
    v_message_id uuid;
    v_conversation_id uuid;
BEGIN
    -- Check if a conversation between sender and receiver exists
    IF EXISTS (
        SELECT id
        FROM public.conversations
        WHERE (user_id_a = p_sender_id AND user_id_b = p_receiver_id)
           OR (user_id_a = p_receiver_id AND user_id_b = p_sender_id)
    ) THEN
        -- Conversation exists, get its ID
        SELECT id INTO v_conversation_id
        FROM public.conversations
        WHERE (user_id_a = p_sender_id AND user_id_b = p_receiver_id)
           OR (user_id_a = p_receiver_id AND user_id_b = p_sender_id);
    ELSE
        -- Conversation does not exist, create a new one
        INSERT INTO public.conversations (user_id_a, user_id_b, conversation_type)
        VALUES (p_sender_id, p_receiver_id, 'USER')
        RETURNING id INTO v_conversation_id;
    END IF;

    -- Insert the message
    INSERT INTO public.messages (conversation_id, user_id, context)
    VALUES (v_conversation_id, p_sender_id, p_message_text)
    RETURNING id INTO v_message_id;

    -- Insert attachments if provided
    IF p_file_id IS NOT NULL OR p_image_id IS NOT NULL THEN
        INSERT INTO public.message_attachments (message_id, file_id, image_id)
        VALUES (v_message_id, p_file_id, p_image_id);
    END IF;
END;
$$ LANGUAGE plpgsql;
