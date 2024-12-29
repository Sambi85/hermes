class CreateJoinTableMessagesUsers < ActiveRecord::Migration[6.1]
  def up
    create_join_table :messages, :users do |t|
      t.index :message_id
      t.index :user_id
      t.index [:message_id, :user_id], unique: true 
    end
  end

  def down
    drop_join_table :messages, :users
  end
end
