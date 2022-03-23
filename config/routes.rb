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
  resources :users_crud
  
  root "home#index"
end
