require 'rails_helper'

RSpec.describe User, type: :model do

  it "is valid with a name and email" do
    user = User.new(name: "John Doe", email: "john@example.com")
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user = User.new(name: nil, email: "john@example.com")
    expect(user).not_to be_valid
  end

  it "is invalid without an email" do
    user = User.new(name: "John Doe", email: nil)
    expect(user).not_to be_valid
  end

  it "is invalid with a duplicate email" do
    User.create!(name: "John Doe", email: "john@example.com")
    user = User.new(name: "Jane Doe", email: "john@example.com")
    expect(user).not_to be_valid
  end

  # Test associations
  it { should have_and_belong_to_many(:conversations) }
  it { should have_many(:messages) }

  # Test HABTM relationship (User can be added to a conversation)
  it "can be added to a conversation" do
    user = User.create!(name: "John Doe", email: "john@example.com")
    conversation = Conversation.create!(name: "General Chat")
    conversation.users << user 

    expect(conversation.users).to include(user)
    expect(user.conversations).to include(conversation)
  end

  # Test messages association
  it "can have messages" do
    user = User.create!(name: "John Doe", email: "john@example.com")
    conversation = Conversation.create!(name: "General Chat")
    conversation.users << user
    message = Message.create!(conversation: conversation, body: "Hello World", user: user)
    
    expect(user.messages).to include(message)
    expect(message.user).to eq(user)
  end
end
