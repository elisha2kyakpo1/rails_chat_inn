class User < ApplicationRecord
  has_secure_passwords
  has_many :messages, dependent: :destroy
end
