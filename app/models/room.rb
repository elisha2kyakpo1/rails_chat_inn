class Room < ApplicationRecord
  validates :name, presence: true
  scope :public_rooms, -> { where(is_private: false) }
end
