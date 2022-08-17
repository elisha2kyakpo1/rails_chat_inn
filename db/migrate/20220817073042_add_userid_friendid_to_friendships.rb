class AddUseridFriendidToFriendships < ActiveRecord::Migration[7.0]
  def change
    add_column :friendships, :userid_friendid, :string
  end
end
