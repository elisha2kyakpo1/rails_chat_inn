class User < ApplicationRecord
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

  private

  def broadcast_update
    broadcast_replace_to 'user_status', partial: 'users/status', user: self
  end
end
