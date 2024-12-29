class DropTwilioCredentials < ActiveRecord::Migration[6.1]
  def change
    drop_table :twilio_credentials, if_exists: true
  end
end