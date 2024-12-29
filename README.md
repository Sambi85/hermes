# Hermes
I've always wanted to build a chat app as a side project. In this project I'll be utilizing Action Cable + SMS messaging. I'm excited to share my progress with you. 

# Frameworks
  - Ruby on Rails => for the backend
  - ActionCable => for real-time communication

# Services
TwilioService
  - Handles Twilio API connection => handles sending SMS messages

# Databases
  - Postgres => handles data persistence (storing users, messages, conversations, etc.).
  - Redis => is required for real-time communication through ActionCable to broadcast messages across multiple clients in a scalable way.

# Logging
  - Rails provides different log levels (debug, info, warn, error, fatal, unknown) which you can use depending on the importance of the message.
  - The current logging strategy...
      debug: Detailed information, typically useful for debugging.
      info: General information about the application's operation.
      warn: Warnings about potential issues.
      error: Errors that occur in the application.
      fatal: Severe errors that cause the application to stop.
      unknown: Unknown messages that don't fit into other categories.

# Noteworthy Gems
  - Twilio-ruby => for Twilio API connection

  testing
     - Shoulda-matchers => for testing active record models + relationships
     - database_cleaner-active_record => for cleaning up the database between tests

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


# Next Steps...
- Test Twilio API connection
- Add rate limiting to Twilio API connection
- Write a mock test to check Twilio API connection, Webmock
- Setup redis
- Add ActionCable + Channels for real time messaging
- validate email address with method/regular expression
- validate phone number with method/regular expression
- Group Messages: need to make single message per each user
- db migration on Message table, receipient_id => array of user_ids
- Permissions => Admin, User
- Add OAuth 2 to User model
- Frontend lay out => Hotwire? or React?