class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  has_and_belongs_to_many :recipients, class_name: 'User'

  validates :body, presence: true, length: { maximum: 300 }
  validates :user, presence: true
  before_validation :must_have_at_least_one_recipient

  after_create_commit do
    broadcast_to conversation, message: self.body
  end

  def must_have_at_least_one_recipient
    if recipients.empty?
      errors.add(:recipients, "must have at least one recipient")
      Rails.logger.warn("Message #{self.id} validation failed: no recipients provided")
    elsif recipients.any? { |recipient| !recipient.is_a?(User) }
      errors.add(:recipients, "must be valid users")
      Rails.logger.warn("Message #{self.id} validation failed: invalid recipient provided")
    end
  end

end
