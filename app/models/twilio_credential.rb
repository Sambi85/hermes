class TwilioCredential < ApplicationRecord
  validates :account_sid, :auth_token, :phone_number, presence: true
end
