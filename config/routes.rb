Rails.application.routes.draw do
  resources :categories do
    resources :field_groups, only: [:create, :update, :destroy]
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
