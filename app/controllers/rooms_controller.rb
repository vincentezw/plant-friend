# frozen_string_literal: true

# Controller for rooms
class RoomsController < ApplicationController
  def index
    @rooms = Room.all.order(:name).paginate(page: params[:page], per_page: 20)
  end

  def show
    @room = Room.find(params[:id])
    @plants = @room.plants.order(:name)
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.save!
    redirect_to @room
  rescue StandardError => e
    @error = e
    render template: 'errors/show', status: :unprocessable_entity
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])

    @room.update!(room_params)
    redirect_to @room
  rescue StandardError => e
    @error = e
    render template: 'errors/show', status: :unprocessable_entity
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    redirect_to root_path, status: :see_other
  end

  private

  def room_params
    params.require(:room).permit(:name, :sun_level)
  end
end
