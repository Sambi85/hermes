# Hermes
- a sandbox messaging App
- Simple Data Modeling
- Unit Tests in Rspec
- Basic logging strategy
- Twilio API gem for messaging

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
- Foreign Key => User_id
- Foreign Key => Conversation_id

Message
- belongs to User
- belongs to Conversation

Twilo Crediental
- no associations

# Notes on running tests your local
RAILS_ENV=test bundle exec rspec
RAILS_ENV=test bundle exec rspec spec/models/<TARGET MODEL NAME>_spec.rb

# Notes on Logging
Rails provides different log levels (debug, info, warn, error, fatal, unknown) which you can use depending on the importance of the message.

debug: Detailed information, typically useful for debugging.
info: General information about the application's operation.
warn: Warnings about potential issues.
error: Errors that occur in the application.
fatal: Severe errors that cause the application to stop.
unknown: Unknown messages that don't fit into other categories.