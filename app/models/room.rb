class Room < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  has_rich_text :contents
  scope :public_rooms, -> { where(is_private: false) }
  scope :private_rooms, -> { where(is_private: true) }
end
