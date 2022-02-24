class Message < ApplicationRecord
  belongs_to :user, depedent: :destroy
  has_rich_text :content
  belongs_to :parent, class_name: 'Message', optional: true
  validates :content, presence: true
end
