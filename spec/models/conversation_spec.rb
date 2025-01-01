require 'rails_helper'

RSpec.describe Conversation, type: :model do
  it "is valid with a name" do
    conversation = Conversation.new(name: "General Chat")
    expect(conversation).to be_valid
  end

  it "is invalid without a name" do
    conversation = Conversation.new(name: nil)
    expect(conversation).not_to be_valid
  end

  it { should have_and_belong_to_many(:users) }
  it { should have_many(:messages) }

  it "can have users" do
    user1 = User.create!(name: "John Doe", email: "john@example.com", phone_number: "01234567890")
    user2 = User.create!(name: "Jane Doe", email: "jane@example.com", phone_number: "09876543210")
    conversation = Conversation.create!(name: "General Chat")
    
    conversation.users << user1
    conversation.users << user2
    
    expect(conversation.users).to include(user1, user2)
    expect(user1.conversations).to include(conversation)
    expect(user2.conversations).to include(conversation)
  end

  it "can have messages" do
    user1 = User.create!(name: 'John Doe', email: 'john@example.com', phone_number: '01334567890')
    user2 = User.create!(name: 'Pasta Master', email: 'ilovepasta@pasta.com', phone_number: '01234367890')

    conversation = Conversation.create!(name: "General Chat")
    conversation.users << user1
    conversation.users << user2

    message = Message.create!(conversation: conversation, body: "Hello World", user: user1, recipients: [user2])
    
    expect(conversation.messages).to include(message)
    expect(message.conversation).to eq(conversation)
    expect(message.user).to eq(user1)
  end

  it "does not add the same user twice" do
    user = User.create!(name: "John Doe", email: "john@example.com", phone_number: "11234567890")
    conversation = Conversation.create!(name: "General Chat")
    
    conversation.users << user
    conversation.users << user  # Trying to add the same user again
    
    conversation.valid?
    puts conversation.errors.full_messages
  end

  it "does not allow for direct modification of users" do
    user = User.create!(name: "John Doe", email: "john@example.com", phone_number: "11234567890")  
    conversation = Conversation.create!(name: "General Chat")
    
    begin
      conversation.users << user  # Trying to add the same user again
    rescue StandardError => e
      expect(e.message).to eq("Direct modification of users is not allowed. Use `add_user` instead.")
    end
    
    conversation.valid?
    puts conversation.errors.full_messages
  end
end

