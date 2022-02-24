Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'posts#index'
  delete '/logout', to: 'sessions#logout_user'
  resources :sessions, only: %i[new create]
  resources :posts
    # resources :comments, only: %i[index create show]
  resources :users, only: %i[index show new create]
end
