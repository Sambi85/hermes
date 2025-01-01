require 'rails_helper'

RSpec.describe Conversation, type: :model do

  it "is valid with a name" do
    conversation = create(:conversation)
    expect(conversation).to be_valid
  end

  it "is invalid without a name" do
    conversation = build(:conversation, name: nil)
    expect(conversation).not_to be_valid
  end

  it { should have_and_belong_to_many(:users) }
  it { should have_many(:messages) }

  it "can have users" do
    user1 = create(:user)
    user2 = create(:user)
    conversation = build(:conversation, users: [user1, user2])
    expect(conversation.users).to include(user1, user2)
  end

  it "can have messages" do
    user1 = create(:user)
    user2 = create(:user)
    conversation = build(:conversation, users: [user1, user2])
    message = build(:message, custom_conversation: conversation, custom_user: user1, custom_recipients: [user2])
    conversation.messages << message

    expect(conversation.messages).to include(message)
    expect(message.conversation).to eq(conversation)
    expect(message.user).to eq(user1)
  end

  it "does not add the same user twice" do
    user = create(:user)
    conversation = create(:conversation, users:[user])
    conversation.users << user  # Trying to add the same user again
    
    conversation.valid?
    puts conversation.errors.full_messages
  end

  it "does not allow for direct modification of users" do
    user = create(:user) 
    conversation = create(:conversation)
    
    begin
      conversation.users << user  # Trying to add the same user again
    rescue StandardError => e
      expect(e.message).to eq("Direct modification of users is not allowed. Use `add_user` instead.")
    end
    
    conversation.valid?
    puts conversation.errors.full_messages
  end
end

