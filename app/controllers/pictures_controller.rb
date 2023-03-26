# frozen_string_literal: true

# Controller for pictures
class PicturesController < ApplicationController
  def show
    @picture = Picture.find(params[:id])
  end

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new(picture_params)
    @picture.image_derivatives! # generate derivatives
    @picture.save!
    redirect_to @picture
  rescue StandardError => e
    @error = e
    render template: 'errors/show', status: :unprocessable_entity
  end

  private

  def picture_params
    params.require(:picture).permit(:description, :image, :plant_id)
  end
end
