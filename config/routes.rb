Rails.application.routes.draw do
  resources :field_groups
  resources :categories do
    resources :fields
    resources :field_groups, only: [:create, :update, :sort_up, :sort_down, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end

    resources :element_kinds, only: [:create, :update, :destroy]
    resources :element_groups, only: [:create, :update, :sort_up, :sort_down, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end

    resources :item_types, only: [:update]

    collection do
      post :import
    end

    member do
      get :export
    end
  end
  #/=categories

  resources :elements do
    member do
      post :sort_up, :sort_down
    end
    resources :field_groups, only: [:create, :update, :sort_up, :sort_down, :destroy] do
      member do
        post :sort_up, :sort_down
      end
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

  resources :element_kinds, only: [] do
    resources :elements, only: [:create, :update, :sort_up, :sort_down, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
  end

  resources :artists do
    resources :item_types, only: [:create, :update, :show, :sort_up, :sort_down, :destroy] do
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

  resources :suppliers, except: [:new, :edit] do
    resources :invoices, except: [:index]
  end

  resources :invoices, only: [] do
    resources :items, except: [:index]
  end

  resources :items do
    resources :values, except: [:index]
  end

  root to: 'categories#index'
end
