Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'rooms#index'
  get '/logout', to: 'sessions#logout_user'
  resources :sessions
  resources :rooms do
    resources :messages
  end

  # resources :comments, only: %i[index create show]
  resources :users, only: %i[index show new create]
end
