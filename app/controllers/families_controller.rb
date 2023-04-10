# frozen_string_literal: true

# Controller for rooms
class FamiliesController < ApplicationController
  def index
    @families = Family.all.order(:name).paginate(page: params[:page], per_page: 20)
  end

  def new
    @family = Family.new
  end

  def import
    @family = Family.new
    @api = ENV['PERENUAL_API_CODE']
  end

  def create
    @family = Family.new(family_params)
    @family.save!
    redirect_to 'index'
  rescue StandardError => e
    puts e
    render :new, status: :unprocessable_entity
  end

  def edit
    @family = Family.find(params[:id])
  end

  def update
    @family = Family.find(params[:id])

    @family.update!(family_params)
    redirect_to @family
  rescue StandardError => e
    @error = e
    render template: 'errors/show', status: :unprocessable_entity
  end

  def destroy
    @family = Family.find(params[:id])
    @family.destroy
    redirect_to root_path, status: :see_other
  end

  private

  def family_params
    params.require(:family).permit(:name, :latin_name, :watering_frequency, :misting, :preferred_room, :description,
                                   :cleaning)
  end
end
