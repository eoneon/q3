Rails.application.routes.draw do
  resources :elements, only: [:index, :show]
  resources :product_elements, only: [:index, :show]



  # resources :categories do
  #   resources :sub_categories, only: [:create, :update]
  #   resources :item_groups, only: [:create, :destroy] do
  #     member do
  #       post :sort_up, :sort_down
  #     end
  #   end
  # end
  #
  # resources :products do
  #   resources :product_item_groups, only: [:create, :destroy] do
  #     member do
  #       post :sort_up, :sort_down
  #     end
  #   end
  # end
  #
  # resources :product_parts do
  #   resources :sub_parts, only: [:create, :update]
  #   resources :item_fields, only: [:update]
  #   resources :sub_fields, only: [:create]
  #   resources :item_groups, only: [:create, :destroy] do
  #     member do
  #       post :sort_up, :sort_down
  #     end
  #   end
  #   collection do
  #     post :import
  #   end
  # end
  #
  # resources :search_product_parts, only: [:index]
  # resources :search_fields, only: [:index]
  # resources :search_values, only: [:index]
  #
  # resources :item_fields do
  #   resources :item_values, only: [:update]
  #   resources :sub_values, only: [:create]
  #   resources :item_groups, only: [:create, :destroy] do
  #     member do
  #       post :sort_up, :sort_down
  #     end
  #   end
  #   collection do
  #     post :import
  #   end
  # end
  #
  # resources :item_values do
  #   resources :item_groups, only: [:create, :destroy] do
  #     member do
  #       post :sort_up, :sort_down
  #     end
  #   end
  #   collection do
  #     post :import
  #   end
  # end
  #
  # resources :product_kinds do
  #   collection do
  #     post :import
  #   end
  # end

  root to: 'elements#index'
end
