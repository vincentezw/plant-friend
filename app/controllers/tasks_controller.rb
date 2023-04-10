# frozen_string_literal: true
# typed: true

# Tasks controller
class TasksController < ApplicationController
  extend T::Sig

  # A task that needs doing
  class TodoTask < T::Struct
    const :task_type, Task::TaskActionType
    const :plant, Plant
    const :last_task, T.nilable(Task)
    const :due_since, T.nilable(Integer)
  end

  before_action :initialize_task, only: [:index]

  def new
    @task = Task.new
  end

  def update
    @task = Task.find(params[:id])
    snooze_time = params[:task][:snooze_time].to_i
    raise "Invalid snooze time: #{snooze_time}" unless [1, 2, 5].include?(snooze_time)

    @task.update!(snooze_time: snooze_time.days.from_now)
    redirect_to root_path
  rescue StandardError => e
    @error = e
    render template: 'errors/show', status: :unprocessable_entity
  end

  def create
    @task = Task.new(task_params)

    @task.save!
    redirect_to '/'
  rescue StandardError => e
    @error = e
    render template: 'errors/show', status: :unprocessable_entity
  end

  # rubocop:disable Metrics/BlockLength
  def index
    tasks = todo_tasks
    Plant.all.each do |plant|
      last_water_tasks = plant.last_water_tasks
      last_water_tasks_not_skipped = plant.last_water_tasks_not_skipped

      if should_water(last_water_tasks)
        due_since = due_since(plant, last_water_tasks[0])
        needs_fertilising = plant.fertilise_time &&
                            (last_water_tasks_not_skipped[3]&.task_name == 'fertilise') ||
                            last_water_tasks[0]&.task_name == 'skipfertilise'

        tasks.push(
          TodoTask.new(
            task_type: needs_fertilising ? Task::TaskActionType::Fertilise : Task::TaskActionType::Water,
            plant:,
            last_task: last_water_tasks[0],
            due_since:
          )
        )
      end

      if plant.cleaning
        last_clean_task = plant.last_clean_task
        should_clean = last_clean_task.nil? || (last_clean_task.created_at < 60.days.ago.beginning_of_day &&
          (last_clean_task.snooze_time.nil? || last_clean_task.snooze_time < Time.zone.now.beginning_of_day))

        if should_clean
          tasks.push(
            TodoTask.new(
              task_type: Task::TaskActionType::Clean,
              plant:,
              last_task: last_clean_task
            )
          )
        end
      end
      next unless plant.misting

      last_mist_task = plant.last_mist_task
      should_mist = last_mist_task.nil? || (last_mist_task.created_at < 2.days.ago.beginning_of_day &&
        (last_mist_task.snooze_time.nil? || last_mist_task.snooze_time < Time.zone.now.beginning_of_day))

      next unless should_mist

      todo_task = TodoTask.new(
        task_type: Task::TaskActionType::Mist,
        plant:,
        last_task: last_mist_task
      )
      tasks.push(todo_task)
    end

    @grouped_tasks = group_tasks(tasks)
  end
  # rubocop:enable Metrics/BlockLength

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to root_path, status: :see_other
  end

  private

  def group_tasks(tasks)
    grouped = []

    Task::TaskActionType.each_value do |task_type|
      next if task_type.serialize.start_with?('skip')

      grouped.push(
        {
          name: task_type.serialize.capitalize,
          tasks: tasks.select { |t| t.task_type == task_type }
        }
      )
    end
    grouped
  end

  def due_since(plant, task)
    return nil if task.nil?

    due_since_threshold = (Time.zone.now - (plant.watering_frequency * 1.days))
    return nil if task.created_at > due_since_threshold - 1.day

    if !task.snooze_time.nil? && task.snooze_time < Time.zone.now.beginning_of_day - 1.day
      (Time.zone.now.to_date - task.snooze_time.to_date).to_i
    elsif task.snooze_time.nil?
      (due_since_threshold.to_date - task.created_at.to_date).to_i
    end
  end

  def todo_tasks
    todo_tasks = []
    @completed_tasks = []
    # add task if it was created today, and before 2am the next day
    todays_tasks = Task.all.where(created_at: Time.zone.now.beginning_of_day..(Time.zone.now.end_of_day + 2.hours))
                       .reject { |t| t.task_name.start_with?('skip') }
    todays_tasks.each do |t|
      @completed_tasks.push(
        TodoTask.new(task_type: Task::TaskActionType.deserialize(t.task_name), plant: t.plant, last_task: t)
      )
    end
    todo_tasks
  end

  sig { params(last_water_tasks: T::Array[Task]).returns(T::Boolean) }
  def should_water(last_water_tasks)
    return true if last_water_tasks.empty?

    plant = last_water_tasks.first.plant
    plant_water_time = (Time.zone.now - (plant.watering_frequency * 1.days))
    last_water_tasks.select do |t|
      t.created_at.to_datetime > plant_water_time ||
        (!t.snooze_time.nil? && t.snooze_time > Time.zone.now.beginning_of_day)
    end.empty?
  end

  def task_params
    params.require(:task).permit(:task_name, :plant_id, :snooze_time)
  end

  def initialize_task
    @task = Task.new
  end
end
