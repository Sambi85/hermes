class CreateTwilioCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :twilio_credentials, id: :serial do |t|
      t.string :account_sid
      t.string :auth_token
      t.string :phone_number

      t.timestamps
    end
  end
end
