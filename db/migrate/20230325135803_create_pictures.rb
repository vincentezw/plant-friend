# frozen_string_literal: true

# A picture has a description and a plant
class CreatePictures < ActiveRecord::Migration[7.0]
  def change
    create_table :pictures do |t|
      t.belongs_to :plant
      t.string :description
      t.text :image_data

      t.timestamps
    end
  end
end
