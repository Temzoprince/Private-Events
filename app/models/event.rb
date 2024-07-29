class Event < ApplicationRecord
  # Associations
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_many :attendances
  has_many :attendees, through: :attendances

  def self.past
    all.select { |event| event.date < Date.current }
  end

  def self.upcoming
    all.select { |event| event.date >= Date.current }
  end
end
