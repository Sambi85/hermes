class CreateJoinTableConversationsUsers < ActiveRecord::Migration[6.1]
  def change
    create_join_table :conversations, :users do |t|
      t.index :conversation_id
      t.index :user_id
    end
  end
end