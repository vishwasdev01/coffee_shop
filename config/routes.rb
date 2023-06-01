Rails.application.routes.draw do
  resources :items, only: [:index, :show, :create]
  resources :orders, only: [:index, :show, :create, :update]
  resources :users, only: [:create]
  match 'users/login', to: 'users#login', via: [:post]
end
