Rails.application.routes.draw do
  resources :categories do
    resources :poly_element_kinds, only: [:update, :create]
    resources :element_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
  end
  
  resources :element_kinds do
    resources :elements, only: [:create, :update, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
    resources :poly_fields, only: [:update, :create]
    resources :field_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
  end

  resources :fields do
    resources :values, except: [:index]
    resources :value_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
  end

  resources :elements, only: [] do
    resources :poly_fields, only: [:update, :create]
    resources :field_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
  end
  resources :artists
  resources :suppliers
  # resources :artists do
  #   resources :item_types, only: [:create, :update, :show, :sort_up, :sort_down, :destroy] do
  #     member do
  #       post :sort_up, :sort_down
  #     end
  #   end
  #   collection do
  #     get :search
  #   end
  #
  #   member do
  #     get :export
  #   end
  # end

  # resources :suppliers, except: [:new, :edit] do
  #   resources :invoices, except: [:index]
  # end
  #
  # resources :invoices, only: [] do
  #   resources :items, except: [:index]
  # end
  #
  # resources :items do
  #   resources :values, except: [:index]
  # end

  root to: 'element_kinds#index'
end
