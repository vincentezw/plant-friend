# frozen_string_literal: true

# Create tasks table
class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :task_name
      t.timestamp :snooze_time, default: nil
      t.integer :plant_id

      t.timestamps
      t.index %i[plant_id task_name]
    end
  end
end
