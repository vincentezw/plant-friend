# frozen_string_literal: true

# Model for families
class Family < ApplicationRecord
  has_many :plants, dependent: :destroy
  validates :watering_frequency, presence: true, numericality: {
    only_integer: true,
    greater_than: 1,
    less_than_or_equal_to: 365
  }
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :latin_name, length: { maximum: 50 }
  validates :description, length: { maximum: 500 }

  VALID_SUNLEVELS = ::Room::SunLevel.values.map { |level| level.serialize.downcase }
  validates :preferred_room, presence: true, inclusion: { in: VALID_SUNLEVELS }
  validates :misting, inclusion: { in: [true, false] }
  validates :cleaning, inclusion: { in: [true, false] }
end
