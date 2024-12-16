# hermes
- a sandbox messaging App


# Data Models
User
- has many + belongs to Conversations
- has many messages
*** has_and_belongs_to_many => association tells Rails to look for the join table

Conversation
- has many + belongs to Users
- has many Messages
*** has_and_belongs_to_many => association tells Rails to look for the join table

User_Conversation
- Join Table

Message
- belongs to User
- belongs to Conversation

Twilo Crediental
- no associations

# Running Tests in Local
RAILS_ENV=test bundle exec rspec
RAILS_ENV=test bundle exec rspec spec/models/<TARGET MODEL NAME>_spec.rb
