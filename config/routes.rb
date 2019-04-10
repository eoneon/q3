Rails.application.routes.draw do
  resources :products do
    resources :item_groups, only: [:create, :destroy]
    collection do
      post :import
    end
  end

  resources :product_parts do
    resources :sub_parts, only: [:update]
    resources :item_fields, only: [:update]
    resources :item_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
    collection do
      post :import
    end
  end

  resources :item_fields do
    resources :item_values, only: [:update]
    resources :item_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
    collection do
      post :import
    end
  end

  resources :item_values do
    collection do
      post :import
    end
  end

  resources :product_kinds do
    collection do
      post :import
    end
  end

  #
  # resources :categories do
  #   collection do
  #     post :import
  #   end
  #   resources :poly_element_kinds, only: [:update, :create]
  #   resources :element_groups, only: [:create, :destroy] do
  #     member do
  #       post :sort_up, :sort_down
  #     end
  #   end
  #   resources :element_joins, only: [:create, :destroy] do
  #     member do
  #       post :sort_up, :sort_down
  #     end
  #   end
  #   resources :elements, only: [:update, :destroy]
  # end
  #
  # resources :element_kinds do
  #   collection do
  #     post :import
  #   end
  #   resources :elements, only: [:create, :update, :destroy]
  #   resources :element_joins, only: [:create, :destroy] do
  #     member do
  #       post :sort_up, :sort_down
  #     end
  #   end
  #   resources :poly_fields, only: [:update, :create]
  #   resources :field_groups, only: [:create, :destroy] do
  #     member do
  #       post :sort_up, :sort_down
  #     end
  #   end
  # end
  #
  # resources :fields do
  #   collection do
  #     post :import
  #   end
  #   resources :values, except: [:index]
  #   resources :value_groups, only: [:create, :destroy] do
  #     member do
  #       post :sort_up, :sort_down
  #     end
  #   end
  # end
  #
  # resources :elements, only: [:index, :destroy] do
  #   collection do
  #     post :import
  #   end
  #   resources :poly_fields, only: [:update, :create]
  #   resources :field_groups, only: [:create, :destroy] do
  #     member do
  #       post :sort_up, :sort_down
  #     end
  #   end
  # end
  #
  # resources :values, only: [:index, :destroy] do
  #   collection do
  #     post :import
  #   end
  # end

  # resources :artists
  # resources :suppliers
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

  root to: 'product_kinds#index'
end
