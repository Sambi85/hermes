class Conversation < ApplicationRecord
  has_and_belongs_to_many :users, before_add: :user_exists
  has_many :messages

  validates :name, presence: true

  # Adds a user to the conversation, rescuing from duplicate key errors
  def add_users(user)
    users << user
  end

  private

  # Check if the user already exists in the conversation
  def user_exists(user)
    if users.include?(user)
      errors.add(:base, "User is already part of this conversation")
      throw(:abort)  # Prevents adding the user to the conversation
    end
  end
end