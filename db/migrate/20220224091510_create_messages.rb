class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :parent_id, null: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
