Rails.application.routes.draw do
  resources :categories do
    resources :field_groups, only: [:create, :update, :sort_up, :sort_down, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end

    resources :sub_categories, only: [:create, :update, :sort_up, :sort_down, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end

    collection do
      post :import
    end

    member do
      get :export
    end
  end

  resources :dimensions do
    resources :field_groups, only: [:create, :update, :sort_up, :sort_down, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
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
