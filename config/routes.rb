Rails.application.routes.draw do
  resources :categories do
    collection do
      post :import
    end
  end

  resources :fields do
    collection do
      post :import
    end
  end

  root to: 'categories#index'
end
