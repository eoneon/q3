Rails.application.routes.draw do
  resources :products do
    resources :item_groups, only: [:create, :destroy]
    collection do
      post :import
    end
  end

  resources :product_parts do
    resources :sub_parts, only: [:create, :update]
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

  resources :search_product_parts, only: [:index]

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
