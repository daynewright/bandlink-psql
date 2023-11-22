DROP FUNCTION IF EXISTS get_users_for_event(uuid);

CREATE OR REPLACE FUNCTION get_users_for_event(p_event_id uuid)
RETURNS TABLE (
    user_id uuid,
    full_name text,
    image_path text,
    attendance_status text
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        up.id AS user_id,
        up.first_name || ' ' || up.last_name AS full_name,
        i.image_path,
        COALESCE(ea.status::text, 'NOT_ATTENDING') AS attendance_status
    FROM
        public.users_profile up
    JOIN
        public.event_attendance ea ON up.id = ea.user_id AND ea.event_id = p_event_id
    LEFT JOIN
        public.images i ON up.profile_image_id = i.id;
END;
$$ LANGUAGE plpgsql;