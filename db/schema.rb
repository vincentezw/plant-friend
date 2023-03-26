# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_25_135803) do
  create_table "families", force: :cascade do |t|
    t.string "name"
    t.string "latin_name"
    t.integer "watering_frequency"
    t.boolean "misting"
    t.boolean "cleaning"
    t.string "preferred_room"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.integer "plant_id"
    t.string "description"
    t.text "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_id"], name: "index_pictures_on_plant_id"
  end

  create_table "plants", force: :cascade do |t|
    t.string "name"
    t.string "health"
    t.boolean "fertilise"
    t.boolean "fertilise_in_winter"
    t.integer "room_id"
    t.integer "family_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_plants_on_family_id"
    t.index ["room_id"], name: "index_plants_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.string "sun_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "task_name"
    t.datetime "snooze_time", precision: nil
    t.integer "plant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_id", "task_name"], name: "index_tasks_on_plant_id_and_task_name"
  end

end
