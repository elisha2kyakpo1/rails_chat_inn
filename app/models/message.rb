class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user
  has_rich_text :content
  belongs_to :parent, class_name: 'Message', optional: true
  validates :content, presence: true
  after_create_commit { broadcast_append_to self.room }
end
