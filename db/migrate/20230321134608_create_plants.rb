# frozen_string_literal: true

# A plant has a name, a health, a room, a family
class CreatePlants < ActiveRecord::Migration[7.0]
  def change
    create_table :plants do |t|
      t.string :name
      t.string :health
      t.boolean :fertilise
      t.boolean :fertilise_in_winter
      t.belongs_to :room
      t.belongs_to :family
      t.timestamps
    end
  end
end
