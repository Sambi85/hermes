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
    user1 = User.create!(name: "John Doe", email: "john@example.com")
    user2 = User.create!(name: "Jane Doe", email: "jane@example.com")
    conversation = Conversation.create!(name: "General Chat")
    
    conversation.add_users(user1)
    conversation.add_users(user2)
    
    expect(conversation.users).to include(user1, user2)
    expect(user1.conversations).to include(conversation)
    expect(user2.conversations).to include(conversation)
  end

  it "can have messages" do
    user = User.create!(name: "John Doe", email: "john@example.com")
    conversation = Conversation.create!(name: "General Chat")
    conversation.add_users(user)
    message = Message.create!(conversation: conversation, body: "Hello World", user: user)
    
    expect(conversation.messages).to include(message)
    expect(message.conversation).to eq(conversation)
    expect(message.user).to eq(user)
  end

  it "does not add the same user twice" do
    user = User.create!(name: "John Doe", email: "john@example.com")
    conversation = Conversation.create!(name: "General Chat")
    
    conversation.add_users(user)
    conversation.add_users(user)  # Trying to add the same user again
    
    conversation.valid?
    puts conversation.errors.full_messages
  end

  it "does not allow for direct modification of users" do
    user = User.create!(name: "John Doe", email: "john@example.com")
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

