Rails.application.routes.draw do
  devise_for :users
  
  # API Routes
  namespace :api do
    namespace :v1 do
      # Authentication routes
      post 'auth/login', to: 'auth#login'
      post 'auth/register', to: 'auth#register'
      post 'auth/logout', to: 'auth#logout'
      
      # Current user routes (no ID needed) - must come before resource routes
      get 'users/profile', to: 'users#profile'
      put 'users/profile', to: 'users#update_profile'
      get 'users/matches', to: 'users#matches'
      
      # User routes
      resources :users, only: [:index, :show, :update] do
        member do
          get 'profile'
          get 'matches'
        end
      end
      
      # Direct resource routes
      resources :experiences, only: [:index, :create, :update, :destroy]
      resources :skills, only: [:index, :create, :update, :destroy]
      resources :answers, only: [:index, :create, :update, :destroy]
      
      # Questions routes
      resources :questions, only: [:index, :show] do
        resources :answers, only: [:index]
      end
      
      # Matching routes
      get 'matching/users', to: 'matching#users'
      get 'matching/calculate/:user_id', to: 'matching#calculate_match'
      get 'matching/compatibility/:user_id/:other_user_id', to: 'matching#compatibility'
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
