Rails.application.routes.draw do
  resources :categories
  resources :fields
  
  root to: 'categories#index'
end
