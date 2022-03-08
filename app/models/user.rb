class User < ApplicationRecord
  has_secure_password
  has_many :messages, dependent: :destroy
  scope :all_except, ->(user) { where.not(id: user) }
end
