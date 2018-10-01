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

    resources :dimensions, only: [:create, :update, :destroy]

    collection do
      post :import
    end

    member do
      get :export
    end

    resources :fields
    resources :dimensions
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
    resources :fields
  end

  resources :fields do
    resources :values, except: [:index]
    collection do
      post :import
    end
  end

  resources :values do
    collection do
      post :import
    end
  end

  resources :artists do
    collection do
      post :import
    end

    member do
      get :export
    end
  end

  resources :suppliers, except: [:new, :edit] do
    resources :invoices, except: [:index]
  end

  resources :invoices, only: [] do
    resources :items, except: [:index]
      # member do
      #   get :create_skus, :export , except: [:index]
      # end
      # collection do
      #   post :import
      # end
    # end
  end

  resources :items do
    resources :values, except: [:index]
  end

  root to: 'categories#index'
end
