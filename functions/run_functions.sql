-- **QUERIES** --

-- EVENTS --
select * from get_events_for_user_in_band('02035133-eb13-47c3-8e40-6664c7c335ef', '9bebd8a9-1354-459a-81a8-45dd9150e665', 1, 10, 'asc');
select * from get_single_event_with_details('3cf2898f-1e80-43aa-a2d9-24d08f35bf10');
select * from get_users_for_event('7cfbe2c1-a79d-4fcf-b54d-f10ca5842c6c');

-- CONVERSATIONS --
select * from get_user_conversations_by_group('02035133-eb13-47c3-8e40-6664c7c335ef');
select * from get_user_conversations_by_user('02035133-eb13-47c3-8e40-6664c7c335ef');

select * from get_conversations_for_event('3cf2898f-1e80-43aa-a2d9-24d08f35bf10');

-- MESSAGES --
select * from get_messages_by_conversation_group('9ed61ea1-a7d3-47fa-808a-25162973e3df','02035133-eb13-47c3-8e40-6664c7c335ef', 10, 1);
select * from get_messages_by_conversation_event('3cf2898f-1e80-43aa-a2d9-24d08f35bf10','02035133-eb13-47c3-8e40-6664c7c335ef', 10, 1);
select * from get_messages_by_conversations_user('02035133-eb13-47c3-8e40-6664c7c335ef','4bfe841e-97f9-4e4c-b285-261393580928', 10, 1);

-- **MUTATIONS** --

-- MESSAGES --
select * from create_message_for_event('3cf2898f-1e80-43aa-a2d9-24d08f35bf10', '02035133-eb13-47c3-8e40-6664c7c335ef', 'Hi. Sending a message AGAIN!');
select * from create_message_for_group('9ed61ea1-a7d3-47fa-808a-25162973e3df', '02035133-eb13-47c3-8e40-6664c7c335ef', 'this is a message for a group...');
select * from create_message_between_users('02035133-eb13-47c3-8e40-6664c7c335ef', '4bfe841e-97f9-4e4c-b285-261393580928', 'Yo! this is a message too!');