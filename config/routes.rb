Rails.application.routes.draw do
  resources :products do
    collection do
      post :import
    end
    resources :item_groups, only: [:create, :destroy]
    #resources :category_kinds, except: [:index]
    resources :poly_element_kinds, except: [:index]
  end

  resources :product_parts, only: [:index] do
    collection do
      post :import
    end
  end

  resources :product_kinds do
    resources :item_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
    resources :media, only: [:create, :destroy]
    resources :signatures, only: [:create, :destroy]
    resources :certificates, only: [:create, :destroy]
    collection do
      post :import
    end
  end

  resources :media, only: [] do
    resources :item_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
    resources :materials, only: [:create, :destroy]
    resources :sub_media, only: [:create, :destroy]
    resources :editions, only: [:create, :destroy]
  end

  resources :materials, only: [] do
    resources :item_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
    resources :dimensions, only: [:create, :destroy]
    resources :mountings, only: [:create, :destroy]
  end

  resources :signatures, only: [] do
    resources :item_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
  end

  resources :certificates, only: [] do
    resources :item_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
  end

  resources :sub_media, only: [] do
    resources :item_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
  end

  resources :editions, only: [] do
    resources :item_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
  end

  resources :mountings, only: [] do
    resources :item_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
    resources :dimensions, only: [:create, :destroy]
  end

  resources :dimensions, only: [] do
    resources :item_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
  end

  resources :categories do
    collection do
      post :import
    end
    resources :poly_element_kinds, only: [:update, :create]
    resources :element_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
    resources :element_joins, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
    resources :elements, only: [:update, :destroy]
  end

  resources :element_kinds do
    collection do
      post :import
    end
    resources :elements, only: [:create, :update, :destroy]
    resources :element_joins, only: [:create, :destroy] do
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
    collection do
      post :import
    end
    resources :values, except: [:index]
    resources :value_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
  end

  resources :elements, only: [:index, :destroy] do
    collection do
      post :import
    end
    resources :poly_fields, only: [:update, :create]
    resources :field_groups, only: [:create, :destroy] do
      member do
        post :sort_up, :sort_down
      end
    end
  end

  resources :values, only: [:index, :destroy] do
    collection do
      post :import
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
