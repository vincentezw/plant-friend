# frozen_string_literal: true

# Controller for plants
class PlantsController < ApplicationController
  extend T::Sig

  before_action :initialize_picture, only: [:show]

  sig { void }
  def index
    @plants = Plant.all.order(:name).paginate(page: params[:page], per_page: 20)
  end

  sig { void }
  def show
    @plant = Plant.find(params[:id])
    @pictures = @plant.pictures.last(5).reverse
    @number_of_pictures = @plant.pictures.count
    @tasks = @plant.tasks.reject { |task| task.task_name.start_with?('skip') }.last(5).reverse

    @next_due = {
      water: next_watering,
      misting: next_misting,
      cleaning: next_cleaning
    }
  end

  def pictures
    @plant = Plant.find(params[:id])
    @pictures = @plant.pictures.all
  end

  def tasks
    @plant = Plant.find(params[:id])
    @tasks = @plant.tasks.paginate(page: params[:page], per_page: 5)
  end

  sig { void }
  def new
    @plant = Plant.new
  end

  sig { void }
  def create
    @plant = Plant.new(plant_params)
    @plant.save!
    water_task = Task.new(plant_id: @plant.id, task_name: 'water')
    mist_task = Task.new(plant_id: @plant.id, task_name: 'mist')
    clean_task = Task.new(plant_id: @plant.id, task_name: 'clean')

    Task.transaction do
      water_task.save!
      mist_task.save! if @plant.misting
      clean_task.save! if @plant.cleaning
    end

    redirect_to @plant
  rescue StandardError => e
    @error = e
    render template: 'errors/show', status: :unprocessable_entity
  end

  def edit
    @plant = Plant.find(params[:id])
  end

  def update
    @plant = Plant.find(params[:id])

    @plant.update!(plant_params)
    redirect_to @plant
  rescue StandardError => e
    @error = e
    render template: 'errors/show', status: :unprocessable_entity
  end

  def destroy
    @plant = Plant.find(params[:id])
    @plant.destroy

    redirect_to '/plants', status: :see_other
  end

  private

  def plant_params
    params.require(:plant).permit(:name, :family_id, :room_id, :fertilise, :fertilise_in_winter, :health)
  end

  def initialize_picture
    @picture = Picture.new
  end

  def next_watering
    last_water_tasks = @plant.last_water_tasks
    last_water_tasks_not_skipped = @plant.last_water_tasks_not_skipped

    needs_watering = last_water_tasks[0].created_at < @plant.watering_frequency.days.ago &&
                     (last_water_tasks[0].snooze_time.nil? ||
                      last_water_tasks[0].snooze_time < Time.zone.now.beginning_of_day)
    needs_fertilising = @plant.fertilise_time &&
                        (last_water_tasks_not_skipped[3]&.task_name == 'fertilise') ||
                        last_water_tasks[0]&.task_name == 'skipfertilise'

    water = nil
    if needs_watering
      water = needs_fertilising ? 'Needs fertilising now' : 'Needs watering now'
    elsif last_water_tasks[0].snooze_time.nil?
      days_ago = ((Time.zone.now - last_water_tasks[0].created_at) / 86_400).round
      water = "Water in #{@plant.watering_frequency - days_ago} #{day_word(days_ago)}"
    else
      days_ago = ((last_water_tasks[0].snooze_time - Time.zone.now) / 86_400).round
      water = "Water in #{days_ago} #{day_word(days_ago)}"
    end
    water
  end

  def next_misting
    return nil unless @plant.misting

    misting = nil
    needs_misting = @plant.last_mist_task.nil? || (@plant.last_mist_task.created_at < 2.days.ago.beginning_of_day &&
      @plant.last_mist_task.snooze_time.nil?) || (!@plant.last_mist_task.snooze_time.nil? &&
        @plant.last_mist_task.snooze_time < Time.zone.now.beginning_of_day)

    if needs_misting
      misting = 'Needs misting now'
    elsif @plant.last_mist_task.snooze_time.nil?
      days_ago = 3 - ((Time.zone.now - @plant.last_mist_task.created_at) / 86_400).round
      misting = "Mist in #{days_ago.round} #{day_word(days_ago)}"
    else
      days_ago = (@plant.last_mist_task.snooze_time - Time.zone.now) / 86_400
      misting = "Mist in #{days_ago} #{day_word(days_ago)}"
    end
    misting
  end

  def next_cleaning
    last_clean_task = @plant.last_clean_task

    cleaning = nil
    if @plant.cleaning
      needs_cleaning = last_clean_task.nil? || (last_clean_task.created_at < 60.days.ago.beginning_of_day &&
        last_clean_task.snooze_time.nil?) || (!last_clean_task.snooze_time.nil? &&
          last_clean_task.snooze_time < Time.zone.now.beginning_of_day)

      if needs_cleaning
        cleaning = 'Needs cleaning now'
      elsif last_clean_task.snooze_time.nil?
        days_ago = 60 - ((Time.zone.now - last_clean_task.created_at) / 86_400).round
        cleaning = "Clean in #{days_ago} #{day_word(days_ago)}"
      else
        days_ago = (last_clean_task.snooze_time - Time.zone.now) / 86_400
        cleaning = "Clean in #{days_ago.round} #{day_word(days_ago)}"
      end
    end
    cleaning
  end

  def day_word(days_ago)
    days_ago == 1 ? 'day' : 'days'
  end
end
