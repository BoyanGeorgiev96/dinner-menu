Rails.application.routes.draw do
  root 'fridge_items#index'
  resources :fridge_items
  resources :recipes
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
