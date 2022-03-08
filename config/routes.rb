Rails.application.routes.draw do
  get 'rooms/index'
  get 'rooms/create'
  get 'rooms/show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'messages#index'
  delete '/logout', to: 'sessions#logout_user'
  resources :sessions, only: %i[new create]
  resources :messages
  resources :rooms, only: %i[new index create show]
  # resources :comments, only: %i[index create show]
  resources :users, only: %i[index show new create]
end
