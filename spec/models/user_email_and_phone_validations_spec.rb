require 'rails_helper'
require 'pry'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:valid_email) { "test@example.com" }
    let(:valid_email_with_spaces) { " Crab@Example.Com " }
    let(:invalid_email_missing_at) { "testexample.com" }
    let(:invalid_email_missing_domain) { "test@.com" }
    let(:valid_phone_number) { "11345678901" }
    let(:invalid_phone_number_short) { "1234567" }
    let(:invalid_phone_number_long) { "12345678901234567890" }

    it 'validates the presence and format of an email' do
      # Valid email
      user = User.new(name: "John Doe", email: valid_email, phone_number: "01234567890")
      user.save!
      expect(user.valid?).to be_truthy

      # Email with spaces, should be trimmed and converted to lowercase
      user = User.new(name: "John Doe", email: valid_email_with_spaces, phone_number: "08234567890")
      user.save!
      expect(user.email).to eq('crab@example.com') # Ensure email is properly formatted

      # Invalid email (missing '@')
      user = User.new(name: "John Doe", email: invalid_email_missing_at, phone_number: "01234567890")
      expect(user.valid?).to be_falsey
      expect(user.errors[:email]).to include("is invalid")

      # Invalid email (missing domain)
      user = User.new(name: "John Doe", email: invalid_email_missing_domain, phone_number: "01234567890")
      expect(user.valid?).to be_falsey
      expect(user.errors[:email]).to include("is invalid")
    end

    it 'validates the presence and format of a phone number' do
      # Valid phone number (should pass)
      user = User.new(name: "John Doe", email: valid_email, phone_number: valid_phone_number)
      user.save!
      expect(user.valid?).to be_truthy

      # Invalid phone number (too short)
      user = User.new(name: "John Doe", email: valid_email, phone_number: invalid_phone_number_short)
      expect(user.valid?).to be_falsey
      expect(user.errors[:phone_number]).to include("must be between 11 and 16 characters and start with '+'")

      # Invalid phone number (too long)
      user = User.new(name: "John Doe", email: valid_email, phone_number: invalid_phone_number_long)
      expect(user.valid?).to be_falsey
      expect(user.errors[:phone_number]).to include("must be between 11 and 16 characters and start with '+'")
    end
  end

  describe '#format_email' do
    it 'removes spaces and converts email to lowercase' do
      user = User.new(name: "John Doe", email: "   Test@Example.Com   ", phone_number: "01234567890")
      user.save!
      expect(user.email).to eq("test@example.com") # Ensure spaces are stripped and email is downcased
    end
  end

  describe '#format_phone_number' do
    it 'removes non-digit characters and ensures the phone number starts with a "+" symbol' do
      user = User.new(name: "John Doe", email: "john@example.com", phone_number: " 1-123-456 7890")
      user.save!
      expect(user.phone_number).to eq("+11234567890") # Ensure non-digit characters are removed and it starts with "+"
    end
  end
end
