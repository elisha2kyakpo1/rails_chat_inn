class User < ApplicationRecord
  has_one_attached :avatar
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_uniqueness_of :name
  scope :all_except, ->(user) { where.not(id: user) }
  scope :filter_by_user_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  enum status: %i[online away offline]

  after_create_commit { broadcast_append_to 'users' }
  after_update_commit { broadcast_update }

  has_many :messages, dependent: :destroy
  has_one :room

  def status_to_css
    case status
    when 'online'
      'bg-success'
    when 'away'
      'bg-warning'
    when 'offline'
      'bg-dark'
    else
      'bg-dark'
    end
  end

  after_commit :add_default_pfp, on: %i[create update]

  def avatar_thumbnail
    avatar.variant(resize_to_limit: [150, 150]).processed
  end

  def chat_avatar
    avatar.variant(resize_to_limit: [50, 50])
  end

  private

  def add_default_avatar
    return if avatar.attached?

    avatar.attach(
      io: File.open(Rails.root.join('app', 'assets', 'images', 'default_profile.jpg')),
      filename: 'default_profile.jpg',
      content_type: 'image/png'
    )
  end

  def broadcast_update
    broadcast_replace_to 'user_status', partial: 'users/status', user: self
  end
end
