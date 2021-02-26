Rails.application.routes.draw do
  root 'users#index'

  resources :users, except: [:destroy]
  resources :questions

  get 'show' => 'users#show'
end
