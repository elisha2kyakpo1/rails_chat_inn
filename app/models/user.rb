class User < ApplicationRecord
  has_secure_password
  has_many :rooms, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms, dependent: :destroy
  scope :all_except, ->(user) { where.not(id: user) }
end
