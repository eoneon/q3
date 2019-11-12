Rails.application.routes.draw do
  resources :elements, only: [:index, :show]
  resources :products, only: [:index, :show]

  root to: 'elements#index'
end
