# frozen_string_literal: true

require 'csv'

families_csv = File.read(Rails.root.join('db', 'families.csv'))
csv = CSV.parse(families_csv, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  f = Family.new
  f.name = row['name']
  f.latin_name = row['latin_name']
  f.watering_frequency = row['watering_frequency']
  f.misting = row['misting']
  f.preferred_room = row['preferred_room']
  f.cleaning = row['cleaning']
  f.description = row['description']
  f.save
end

Family.create([
                {
                  name: 'Spider plant',
                  latin_name: 'Chlorophytum comosum',
                  watering_frequency: 4,
                  misting: true,
                  preferred_room: 'partsun',
                  cleaning: true
                },
                {
                  name: 'Yucca tree',
                  latin_name: 'Yucca elephantipes',
                  watering_frequency: 30,
                  misting: false,
                  preferred_room: 'shade',
                  cleaning: true
                }
              ])

family_one = Family.create(
  name: 'Apache plant',
  latin_name: 'Dracaena deremensis',
  watering_frequency: 3,
  misting: true,
  preferred_room: 'dark',
  cleaning: true
)

room_one = Room.create(name: 'Living room', sun_level: 'partsun')
room_two = Room.create(name: 'Dining room', sun_level: 'dark')

plant_one = Plant.create(
  name: 'Big Apache plant',
  family: family_one,
  fertilise: true,
  fertilise_in_winter: true,
  room: room_one,
  health: 'thriving'
)

plant_two = Plant.create(
  name: 'Small Apache plant',
  family: family_one,
  fertilise: true,
  fertilise_in_winter: true,
  room: room_two,
  health: 'good'
)

Task.create([{
              task_name: ::Task::TaskActionType::Water.serialize,
              plant: plant_one,
              created_at: Time.zone.now - 5.days
            }])

Task.create([{
              task_name: ::Task::TaskActionType::Water.serialize,
              plant: plant_one,
              created_at: Time.zone.now - 3.days - 3.hours
            }])

Task.create([{
              task_name: ::Task::TaskActionType::Water.serialize,
              plant: plant_two,
              created_at: Time.zone.now - 5.days
            }])

Task.create([{
              task_name: ::Task::TaskActionType::Mist.serialize,
              plant: plant_one,
              created_at: Time.zone.now - 5.days
            }])
Task.create([{
              task_name: ::Task::TaskActionType::Water.serialize,
              plant: plant_one,
              created_at: Time.zone.now - 20.days
            }])

Task.create([{
              task_name: ::Task::TaskActionType::Fertilise.serialize,
              plant: plant_one,
              created_at: Time.zone.now - 30.days - 3.hours
            }])
Task.create([{
              task_name: ::Task::TaskActionType::Clean.serialize,
              plant: plant_one,
              created_at: Time.zone.now - 32.days - 3.hours
            }])
