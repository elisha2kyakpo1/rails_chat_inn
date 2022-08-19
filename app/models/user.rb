class User < ApplicationRecord
  has_one_attached :pic
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

  def self.search_data(data)
    if data.present?
      User.where('name LIKE ?', "%#{data}%")
    else
      User.all
    end
  end

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

  def avatar_thumbnail
    pic.variant(resize: '50x50').processed
  end

  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friends, through: :friendships, foreign_key: 'friend_id'

  def friends
    friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
    inverse_friends_array = inverse_friendships.map { |friendship| friendship.user if friendship.confirmed }
    (friends_array + inverse_friends_array).compact
  end

  def pending_friends
    friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  end

  def friend_requests
    inverse_friendships.map { |friendship| friendship.user unless friendship.confirmed }.compact
  end

  def confirm_friend(user)
    friendships = inverse_friendships.find { |friendship| friendship.user == user }
    friendships.confirmed = true
    friendships.save
  end

  def friend?(user)
    friends.include?(user)
  end

  def create_friendship(user_id, user_friendid)
    friendship = friendships.build(friend_id: user_id, userid_friendid: user_friendid)
    friendship.save if friendship.valid?
  end

  def delete_friend(user_friendid)
    friendship = friendships.find_by_userid_friendid(user_friendid)
    friendship ||= inverse_friendships.find_by_userid_friendid(user_friendid)
    friendship.destroy
  end

  private

  def broadcast_update
    broadcast_replace_to 'user_status', partial: 'users/status', user: self
  end
end
