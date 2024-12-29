#Users
user1 = User.create(name: 'Jane Doe', email: 'jane_doe@example.com', phone_number: '+1234567890')
user2 = User.create(name: 'Solid Snake', email: 'solid_snake@example.com', phone_number: '+9876543210')
user3 = User.create(name: 'Super Mario', email: 'super_mario@example.com', phone_number: '+1112223333')

#Conversations
conversation1 = Conversation.create(name: 'Solo Chat')
conversation1.users << user1

conversation2 = Conversation.create(name: '2 Person Chat')
conversation2.users.concat([user1, user2])

conversation3 = Conversation.create(name: '3 Person Chat')
conversation3.users.concat([user1, user2, user3])

#Message Model - Solo Conversation
message1 = Message.create(user: user1, conversation: conversation1, body: "Looks like i'm talking to myself...")

#Message Model - Conversation with 2 Users
message2 = Message.create(user: user1, conversation: conversation2, body: "Snake, Can you hear me, I've found away into this chat app!")
message3 = Message.create(user: user2, conversation: conversation2, body: "Affirmative, How did you get past the Oauth?")

#Message Model - Conversation with 3 Users
message3 = Message.create(user: user2, conversation: conversation3, body: "Snake, I think this chat has been compromised...")
message4 = Message.create(user: user1, conversation: conversation3, body: "Affirmative, switch channels now!")
message5 = Message.create(user: user3, conversation: conversation3, body: "It's ah Me... MMMarrrrio!")



