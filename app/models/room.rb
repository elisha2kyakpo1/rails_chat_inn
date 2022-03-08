class Room < ApplicationRecord
  validates :name, presence: true
  scope :public_rooms, -> { where(is_private: false) }
  scope :private_rooms, -> { where(is_private: true) }
end
