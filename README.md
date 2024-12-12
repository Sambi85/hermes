# hermes
Sandbox Messaging App


# Data Models
User
- has many + belongs to Conversations 
- has many messages

Conversation
- has many + belongs to Users
- has many Messages

Message (Join Table)
- belongs to User
- belongs to Conversation

Twilo Crediental
- no associations