class AddDescriptionToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :description, :text
  end
end
