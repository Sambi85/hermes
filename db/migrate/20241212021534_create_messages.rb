class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages, id: :serial do |t|
      t.references :user, null: false, foreign_key: true
      t.references :conversation, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
