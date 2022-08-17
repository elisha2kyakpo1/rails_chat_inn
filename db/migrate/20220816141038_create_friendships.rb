class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.boolean :confirmed
      t.references :user, index: true, null: false, foreign_key: true
      t.references :friend, index: true

      t.timestamps
    end
  end
end
