class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  has_and_belongs_to_many :recipients, class_name: 'User'

  validates :body, presence: true, length: { maximum: 300 }
  validates :user, presence: true
  validate :must_have_at_least_one_recipient

  def must_have_at_least_one_recipient
    if recipients.empty?
      errors.add(:recipients, "must have at least one recipient")
      Rails.logger.warn("Message #{self.id} validation failed: no recipients provided")
    end
  end
end
