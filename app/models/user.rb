class User < ApplicationRecord
  has_secure_password
  belongs_to :room
  validates_uniqueness_of :name
  has_many :messages, dependent: :destroy
  scope :all_except, ->(user) { where.not(id: user) }
end
