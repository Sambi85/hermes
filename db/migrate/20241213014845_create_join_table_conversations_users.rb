class CreateJoinTableConversationsUsers < ActiveRecord::Migration[6.1]
  def change
    create_join_table :conversations, :users, id: false do |t|
      # Adding indexes for performance
      t.index [:user_id, :conversation_id], unique: true
      t.index [:conversation_id, :user_id], unique: true
      
      # Adding foreign key constraints to ensure referential integrity
      t.foreign_key :users
      t.foreign_key :conversations
    end
  end
end
