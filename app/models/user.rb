class User < ApplicationRecord
  has_and_belongs_to_many :conversations
  has_and_belongs_to_many :messages

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } #built to rails, free format checker!
  validates :phone_number, presence: true, uniqueness: true
  validate :valid_phone_number_length

  before_validation :format_email
  before_save :format_phone_number

  def format_phone_number
    self.phone_number = phone_number.gsub(/[^0-9+]/, '') # Remove all non-digit characters except the plus sign
    self.phone_number = phone_number.sub(/^(\+?)(\d{1,})/, '+\2') # Ensure the number starts with a "+"
  end

  def format_email
    self.email = email.strip.downcase
  end

  private

  def valid_phone_number_length
    formatted_number = phone_number

    Rails.logger.debug("Formatted phone number: #{formatted_number}")

    unless formatted_number.length >= 11 && formatted_number.length <= 16
      Rails.logger.warn("Invalid phone number length: #{formatted_number.length}")
      errors.add(:phone_number, "must be between 11 and 16 characters (including the country code)")
    end
  end

end
