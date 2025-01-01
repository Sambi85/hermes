class AddDeviseFieldsToUsers < ActiveRecord::Migration[6.1]
  def up
    change_table :users, bulk: true do |t|
      # Devise fields
      t.string :encrypted_password, default: "", null: false
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email # Only if using confirmable
      t.string :unlock_token
      t.datetime :locked_at
    end

    # Add indices for faster queries
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :unlock_token, unique: true
  end

  def down
    change_table :users, bulk: true do |t|
      # Remove Devise fields
      t.remove :encrypted_password
      t.remove :reset_password_token
      t.remove :reset_password_sent_at
      t.remove :remember_created_at
      t.remove :confirmation_token
      t.remove :confirmed_at
      t.remove :confirmation_sent_at
      t.remove :unconfirmed_email
      t.remove :unlock_token
      t.remove :locked_at
    end

    # Remove indices
    remove_index :users, :email
    remove_index :users, :reset_password_token
    remove_index :users, :confirmation_token
    remove_index :users, :unlock_token
  end
end
