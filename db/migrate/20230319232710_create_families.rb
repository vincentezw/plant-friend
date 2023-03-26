# frozen_string_literal: true

# Plant table
class CreateFamilies < ActiveRecord::Migration[7.0]
  def change
    create_table :families do |t|
      t.string :name
      t.string :latin_name
      t.integer :watering_frequency
      t.boolean :misting
      t.boolean :cleaning
      t.string :preferred_room
      t.text :description

      t.timestamps
    end
  end
end
