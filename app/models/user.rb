class User < ApplicationRecord
  has_and_belongs_to_many :conversations
  has_many :messages

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true, uniqueness: true
end
