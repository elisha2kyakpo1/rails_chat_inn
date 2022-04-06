class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user
  has_rich_text :content
  belongs_to :parent, class_name: 'Message', optional: true
  validates :content, presence: true
  before_create :confirm_participant
  after_create_commit { broadcast_append_to room }

  def confirm_participant
    if room.is_private
      is_participant = Participant.where(user_id: user.id, room_id: room.id).first
      throw :abort unless is_participant
    end
  end
end
