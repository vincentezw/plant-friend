# frozen_string_literal: true
# typed: true

# Model for tasks
class Task < ApplicationRecord
  extend T::Sig

  # Task action type
  class TaskActionType < T::Enum
    enums do
      Water = new
      Fertilise = new
      Mist = new
      Clean = new
      SkipWater = new
      SkipMist = new
      SkipFertilise = new
      SkipClean = new
    end
  end

  belongs_to :plant

  VALID_ACTIONS = TaskActionType.values.map { |l| l.serialize.downcase }
  validates :task_name, presence: true, inclusion: { in: VALID_ACTIONS }
  validates :plant_id, presence: true

  def past_tense
    case task_name
    when TaskActionType::Water.serialize.downcase
      'Watered'
    when TaskActionType::Mist.serialize.downcase
      'Misted'
    when TaskActionType::Clean.serialize.downcase
      'Cleaned'
    when TaskActionType::Fertilise.serialize.downcase
      'Fertilised'
    else
      'Skipped'
    end
  end
end
