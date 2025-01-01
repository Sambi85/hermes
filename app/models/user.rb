class User < ApplicationRecord
  has_and_belongs_to_many :conversations
  has_and_belongs_to_many :messages

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } #built to rails, free format checker!
  validates :phone_number, presence: true, uniqueness: true
  validate :valid_phone_number_format

  before_validation :format_email
  before_validation :format_phone_number

  def format_phone_number
    return if phone_number.blank?

    self.phone_number = phone_number.gsub(/[^0-9+]/, '') # Remove all non-digit characters except the plus sign
    self.phone_number = phone_number.sub(/^(\+?)(\d{1,})/, '+\2') # Ensure the number starts with a "+"

  end

  def format_email
    return if email.blank?
    self.email = email.strip.downcase
  end

  private

  def valid_phone_number_format
    return if phone_number.blank?
    formatted_number = phone_number

    Rails.logger.debug("Formatted phone number: #{formatted_number}")

    # Check if phone number starts with "+" and is followed by a valid numeric string
    unless phone_number.match(/\A\+?\d{11,16}\z/)
      errors.add(:phone_number, "must be between 11 and 16 characters and start with '+'")
    end
  end

end
