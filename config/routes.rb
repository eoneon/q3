Rails.application.routes.draw do
  resources :categories do
    collection do
      post :import
    end
  end

  resources :fields

  root to: 'categories#index'
end
