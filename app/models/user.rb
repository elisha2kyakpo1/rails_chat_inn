class User < ApplicationRecord
  has_secure_password
  validates_uniqueness_of :name
  has_many :messages, dependent: :destroy
  scope :all_except, ->(user) { where.not(id: user) }
  after_create_commit { broadcast_append_to "users" }
end
