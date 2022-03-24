Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: { 
    registrations: 'users/registrations', 
    sessions: 'users/sessions'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :role
  resources :users

  resources :admin do
    collection do
      get 'soft_delete'
      get "alluser"
    end
  end
  
  root "home#index"
end
