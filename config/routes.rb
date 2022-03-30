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
  resources :users do
    collection do
      post 'create_user'
      
    end
  end

  resources :issues do 
    collection do 
      get 'assign_issue_show'
      patch 'assign_issue'
      get 'my_issue'
    end
  end

  resources :projects do

    resources :sprint do
      resources :task
      collection do
        
      end
    end
    
    resources :task
    collection do

      patch "save_review_rating"
      get "project_status"
      get "review_rating"
     
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
