

#Users
user = User.create(name: 'Jane Doe', email: 'jane_doe@example.com')

#Conversations
conversation = Conversation.create(name: 'General Chat', user_ids: [user.id])

#Message Model
message = Message.create(user: user, conversation: conversation, body: "Hello, world!")

#Twilio Credentials
twilio_credentials = TwilioCredential.create(account_sid: "your_account_sid", auth_token: "your_auth_token", phone_number: "+1234567890")



