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
  - has_and_belongs_to_many to Conversations
  - has many messages
  *** has_and_belongs_to_many => association tells Rails to look for the join table

Conversation
  - has_and_belongs_to_many to Users
  - has many Messages
  *** has_and_belongs_to_many => association tells Rails to look for the join table

User_Conversation
  - Join Table
  - Foreign Key => User_id
  - Foreign Key => Conversation_id

Message
  - belongs to User
  - belongs to Conversation

Messages_Users
  - Join Table
  - has_and_belongs_to_many messages
  - has_and_belongs_to_many :recipients, class_name: 'User'
  *** has_and_belongs_to_many => association tells Rails to look for the join table

# Validations
User
  - Needs a unique username
  - Needs a unique email address
  - Needs a unique phone number

Conversation
  - Needs a name for the conversation

User_Conversation
  - Needs a unique pair => [:user_id, :conversation_id]

Message
  - Needs a body, 300 characters limit
  - Needs a sender/user_id

Messages_Users
  - Needs a unique pair => [:message_id, :recipient_id]

# Next Steps...
- Test Twilio API connection
- Add rate limiting to Twilio API connection
- Write a mock test to check Twilio API connection, Webmock
- Setup redis
- Add ActionCable + Channels for real time messaging
- validate email address with method/regular expression
- validate phone number with method/regular expression
- Group Messages: need to make single message per each user
- Permissions => Admin, User
- Add OAuth 2 to User model
- Frontend lay out => Hotwire? or React?
- DRY up test suite, let's make more fixtures
- Touch ups in test suite => Let's do some linting
- Touch ups in app => Let's do some linting

# Troublshooting + Testing
Run tests in local environment
  - RAILS_ENV=test bundle exec rspec
  - RAILS_ENV=test bundle exec rspec spec/models/<YOUR TARGET TEST FILE>.rb

Using Phone Number in Twilio
  - E.164 is the international telephone numbering plan that ensures each device on the PSTN has globally unique number.
  - Vist here: https://www.twilio.com/docs/glossary/what-e164