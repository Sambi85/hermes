class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :body, presence: true, length: { maximum: 300 }
  validates :user, presence: true
end
