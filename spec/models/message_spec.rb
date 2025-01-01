require 'rails_helper'

RSpec.describe Message, type: :model do
  # Validation tests
  describe "validations" do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_most(300) }
    it { should validate_presence_of(:user) }
    it { should have_and_belong_to_many(:recipients).class_name('User') }

    it "is invalid if the body exceeds 300 characters" do
      user = create(:user)
      conversation = Conversation.create!(name: "General Chat")
      message = Message.new(body: "a" * 301, user: user, conversation: conversation)

      expect(message.valid?).to eq(false)
      expect(message.errors[:body]).to include("is too long (maximum is 300 characters)")
    end

    it "is valid if the body is 300 characters or fewer" do
      user1 = create(:user)
      user2 = create(:user)
      conversation = Conversation.create!(name: 'General Chat')
      message = Message.new(body: 'a' * 300, user: user1, recipients: [user2]  , conversation: conversation)

      expect(message.valid?).to eq(true)
    end

    it "is invalid without a user" do
      message = Message.new(body: "Hello, world!", conversation: Conversation.create!(name: "General Chat"))
      expect(message.valid?).to be(false)
      expect(message.errors[:user]).to include("must exist")
    end
  
    it "is invalid without a conversation" do
      user = create(:user)
      message = Message.new(body: "Hello, world!", user: user)
      expect(message.valid?).to be(false)
      expect(message.errors[:conversation]).to include("must exist")
    end

    it "is valid with a body and recipients" do
      user1 = create(:user)
      user2 = create(:user)
      conversation = Conversation.create!(name: "General Chat")
      message = Message.new(body: "Hello", user: user1, conversation: conversation, recipients: [user2])
  
      expect(message).to be_valid
    end

    it "is invalid without recipients" do
      user = create(:user)
      conversation = Conversation.create!(name: "General Chat")
      message = Message.new(body: "Hello", user: user, conversation: conversation)
  
      expect(message).not_to be_valid
      expect(message.errors[:recipients]).to include("must have at least one recipient")
    end

  end
end
