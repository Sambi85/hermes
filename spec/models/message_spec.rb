require 'rails_helper'

RSpec.describe Message, type: :model do
  # Validation tests
  describe "validations" do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_most(300) }
    it { should validate_presence_of(:user) }

    it "is invalid if the body exceeds 300 characters" do
      user = User.create!(name: "John Doe", email: "john@example.com")
      conversation = Conversation.create!(name: "General Chat")
      message = Message.new(body: "a" * 301, user: user, conversation: conversation)

      expect(message.valid?).to eq(false)
      expect(message.errors[:body]).to include("is too long (maximum is 300 characters)")
    end

    it "is valid if the body is 300 characters or fewer" do
      user = User.create!(name: "John Doe", email: "john@example.com")
      conversation = Conversation.create!(name: "General Chat")
      message = Message.new(body: "a" * 300, user: user, conversation: conversation)

      expect(message.valid?).to eq(true)
    end

    it "is invalid without a user" do
      message = Message.new(body: "Hello, world!", conversation: Conversation.create!(name: "General Chat"))
      expect(message.valid?).to be(false)
      expect(message.errors[:user]).to include("must exist")
    end
  
    it "is invalid without a conversation" do
      user = User.create!(name: "John Doe", email: "john@example.com")
      message = Message.new(body: "Hello, world!", user: user)
      expect(message.valid?).to be(false)
      expect(message.errors[:conversation]).to include("must exist")
    end
  end
end
