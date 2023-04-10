# frozen_string_literal: true

Rails.application.routes.draw do
  root "tasks#index"

  resources :tasks, except: %i[show]
  resources :pictures, only: %i[create destroy show]
  resources :plants
  resources :rooms
  resources :families, except: %i[show]

  get "/plants/:id/pictures", to: "plants#pictures", as: "plant_pictures"
  get "/plants/:id/tasks", to: "plants#tasks", as: "plant_tasks"
  get "/families/import", to: "families#import"
end
