# frozen_string_literal: true

# Model for pictures
class Picture < ApplicationRecord
  include ImageUploader::Attachment(:image)
  validates :description, length: { maximum: 200 }

  belongs_to :plant
end
