Rails.application.routes.draw do
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'home#index'

  resources :rooms do
    resources :messages
  end
  devise_for :users
  resources :users do
    member do
      get 'create_friendship'
      get 'delete_friend'
      get 'confirm_friend'
    end
  end
  resources :friendships, only: %i[create destroy]
end
