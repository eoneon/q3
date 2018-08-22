Rails.application.routes.draw do
  resources :categories do
    resources :field_groups, only: [:create, :update, :sort_up, :sort_down, :destroy] do
    # post '/sort-up' => 'votes#up_vote', as: :up_vote
    # post '/sort-down' => 'votes#down_vote', as: :down_vote
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
