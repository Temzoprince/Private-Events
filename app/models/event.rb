class Event < ApplicationRecord
  # Associations
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_many :attendances
  has_many :attendees, through: :attendances

  # Scopes
  scope :past, ->(date) { where('date < ?', date) }
  scope :upcoming, ->(date) { where('date >= ?', date) }
end
