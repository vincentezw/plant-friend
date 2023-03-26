# frozen_string_literal: true

# Uploading with Shrine
class ImageUploader < Shrine
  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png image/webp]
    validate_max_size  5 * 1024 * 1024
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    {
      small: magick.resize_to_limit!(100, 100),
      thumb: magick.resize_to_fill!(500, 500),
      large: magick.resize_to_limit!(2000, 2000)
    }
  end
end
