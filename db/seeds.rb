

#Users
User.create(name: 'Jane Doe', email: 'jane_doe@example.com')

#Conversations
Conversation.create(name: 'General Chat', user_ids: [user.id])

#Message Model



