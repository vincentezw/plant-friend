# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/file_system'
require 'shrine/storage/memory'
Shrine.storages = if Rails.env.test?
                    {
                      cache: Shrine::Storage::Memory.new,
                      store: Shrine::Storage::Memory.new
                    }
                  else
                    {
                      cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'), # temporary
                      store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads') # permanent
                    }
                  end
Shrine.plugin :activerecord # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data  # extracts metadata for assigned cached files
Shrine.plugin :derivatives
Shrine.plugin :determine_mime_type
Shrine.plugin :validation_helpers
Shrine.plugin :validation
