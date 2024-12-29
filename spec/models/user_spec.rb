require 'rails_helper'
require 'pry'
RSpec.describe User, type: :model do

  it "is valid with a name and email" do
    user = User.new(name: "John Doe", email: "john@example.com", phone_number: "1234567890")
    expect(user).to be_valid
  end

  it "is invalid without a name or phone number" do
    user = User.new(name: nil, email: "john@example.com", phone_number: "1234567890")
    expect(user).not_to be_valid
  end

  it "is invalid without an email" do
    user = User.new(name: "John Doe", email: nil, phone_number: "1234567890")
    expect(user).not_to be_valid
  end

  it "is invalid without a phone number" do
    user = User.new(name: "John Doe", email: "john@example.com", phone_number: nil)
    expect(user).not_to be_valid
  end

  it "is invalid with a duplicate email" do
    User.create!(name: "John Doe", email: "john@example.com", phone_number: "1234567890")
    user = User.new(name: "Jane Doe", email: "john@example.com", phone_number: "1234567890")
    expect(user).not_to be_valid
  end

  it "is invalid with a duplicate phone number" do
      User.create!(name: "John Doe", email: "john@example.com", phone_number: "1234567890")
      user = User.new(name: "Jane Doe", email: "jane@example.com", phone_number: "1234567890")
      expect(user).not_to be_valid
  end

  # Test associations
  it { should have_and_belong_to_many(:conversations) }
  it { should have_and_belong_to_many(:messages) }

  # Test HABTM relationship (User can be added to a conversation)
  it "can be added to a conversation" do
    user = User.create!(name: "John Doe", email: "john@example.com", phone_number: "1234567890")
    conversation = Conversation.create!(name: "General Chat")
    conversation.users << user 

    expect(conversation.users).to include(user)
    expect(user.conversations).to include(conversation)
  end

  # Test messages association
  it "can have messages + recipients" do
    user1 = User.create!(name: "John Doe", email: "john@example.com", phone_number: "1234567890")
    user2 = User.create!(name: "Jimmy Dobber", email: "jimmy_d@example.com", phone_number: "1224567890")
  
    conversation = Conversation.create!(name: "General Chat")
    conversation.users << user1
    conversation.users << user2
  
    message = Message.create!(conversation: conversation, body: "Hello World", user: user1, recipients: [user2])
  
    expect(message.recipients).to include(user2)
    expect(message.user).to eq(user1)
  end
end
