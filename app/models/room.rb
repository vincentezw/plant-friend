# typed: true

# Room model
class Room < ApplicationRecord
  extend T::Sig

  has_many :plants, dependent: :destroy

  # Sun level
  class SunLevel < T::Enum
    enums do
      FullSun = new
      PartSun = new
      Shade = new
      Dark = new
    end
  end

  VALID_SUNLEVELS = SunLevel.values.map { |level| level.serialize.downcase }
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :sun_level, presence: true, inclusion: { in: VALID_SUNLEVELS }
end
