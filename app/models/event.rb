class Event < ApplicationRecord
  # Associations
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_many :attendances
  has_many :attendees, through: :attendances

  # Scopes
  scope :past, -> { where(date: ...Date.today) }
  scope :upcoming, -> { where(date: Date.today..) }
end
