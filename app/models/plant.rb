# typed: true

# Plant model
class Plant < ApplicationRecord
  extend T::Sig

  # Plant health
  class Health < T::Enum
    enums do
      Thriving = new
      Good = new
      Poor = new
      Dead = new
    end
  end

  belongs_to :room
  belongs_to :family
  has_many :actions
  has_many :pictures, dependent: :destroy
  has_many :tasks, dependent: :destroy
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  VALID_HEALTH = Health.values.map { |level| level.serialize.downcase }
  validates :health, presence: true, inclusion: { in: VALID_HEALTH }
  validates :room_id, presence: true
  validates :family_id, presence: true

  def watering_frequency
    family.watering_frequency
  end

  def misting
    family.misting
  end

  def cleaning
    family.cleaning
  end

  def snooze_options(action_type)
    return [] if action_type.serialize.downcase.start_with?('skip')

    options = [['1 day', 1]]
    options.push(['2 days', 2]) if watering_frequency > 2 || action_type == ::Task::TaskActionType::Mist
    unless action_type == ::Task::TaskActionType::Mist
      options.push(['5 days', 5]) if watering_frequency > 5
      options.push(['10 days', 10]) if watering_frequency > 10
    end

    options
  end

  def fertilise_time
    d = Date.today
    fertilise &&
      (d.season != :winter || @plant.fertilise_in_winter)
  end

  def last_water_tasks
    tasks.where(task_name: Task::TaskActionType::Water.serialize)
         .or(tasks.where(task_name: Task::TaskActionType::Fertilise.serialize))
         .or(tasks.where(task_name: Task::TaskActionType::SkipWater.serialize))
         .or(tasks.where(task_name: Task::TaskActionType::SkipFertilise.serialize))
         .order(created_at: :desc).first(5)
  end

  def last_water_tasks_not_skipped
    tasks.where(task_name: Task::TaskActionType::Water.serialize)
         .or(tasks.where(task_name: Task::TaskActionType::Fertilise.serialize))
         .order(created_at: :desc).first(4)
  end

  def last_mist_task
    tasks.where(task_name: Task::TaskActionType::Mist.serialize.downcase)
         .or(tasks.where(task_name: Task::TaskActionType::SkipMist.serialize))
         .order('created_at DESC').first
  end

  def last_clean_task
    tasks.where(task_name: Task::TaskActionType::Clean.serialize.downcase)
         .or(tasks.where(task_name: Task::TaskActionType::SkipClean.serialize))
         .order('created_at DESC').first
  end
end
