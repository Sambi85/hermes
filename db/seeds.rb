#Users
user1 = User.create(name: 'Luigi', email: 'luigi@example.com', phone_number: '11234567890', password: 'password', password_confirmation: 'password')
user2 = User.create(name: 'Solid Snake', email: 'solid_snake@example.com', phone_number: '11234567891', password: 'password', password_confirmation: 'password')
user3 = User.create(name: 'Super Mario', email: 'super_mario@example.com', phone_number: '11234567892', password: 'password', password_confirmation: 'password')
user4 = User.create(name: 'Donkey Kong', email: 'donkey_kong@example.com', phone_number: '11234567893', password: 'password', password_confirmation: 'password')
user5 = User.create(name: 'Kirby', email: 'kirby@example.com', phone_number: '11234567894', password: 'password', password_confirmation: 'password')

#Conversations w/o Messages
conversation1 = Conversation.create(name: '1 Person')
conversation1.users.concat([user1])

conversation2 = Conversation.create(name: '2 Person')
conversation2.users.concat([user1, user2])

conversation3 = Conversation.create(name: '3')
conversation3.users.concat([user1, user2, user3])

#Message Model - Solo Conversation
message1 = Message.create(user: user1, conversation: conversation1, body: "test message", recipients: [user2])

#Message Model - Conversation with 2 Users
message2 = Message.create(user: user1, conversation: conversation2, body: "test message", recipients: [user3])
message3 = Message.create(user: user2, conversation: conversation2, body: "test message", recipients: [user1])

#Message Model - Conversation with 3 Users
message3 = Message.create(user: user2, conversation: conversation3, body: "test message", recipients: [user1])
message4 = Message.create(user: user1, conversation: conversation3, body: "test message", recipients: [user2])
message5 = Message.create(user: user3, conversation: conversation3, body: "test message", recipients: [user3])

#Conversations w/ Messages
# 1 message, users: [user1], 1 person conversation
conversation1 = Conversation.create(name: '1 Person')
conversation1.users.concat([user1])
conversation1.messages.concat([message1])

# 2 messages, users: [user1, user2], 2 person conversation
conversation2 = Conversation.create(name: '2 Person')
conversation2.users.concat([user1, user2])
conversation2.messages.concat([message2, message3])

# 3 messages, users: [user1, user2, user3], 3 person conversation
conversation3 = Conversation.create(name: '3 Person')
conversation3.users.concat([user1, user2, user3])
conversation3.messages.concat([message4, message5, message3])

