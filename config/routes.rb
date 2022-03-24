# frozen_string_literal: true

Rails.application.routes.draw do
  # devise_for :users
  default_url_options :host => ENV['HOST']
  devise_for :users, controllers: { 
    registrations: 'users/registrations', 
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :role
  resources :users 


  resources :projects
  # post "/users", to: "users#create_user"

  resources :users do
    collection do
      post 'create_user'
    end
  end
  
  resources :admin do
    collection do
      get 'soft_delete'
      get "alluser"
    end
  end
  
  root "home#index"
end
