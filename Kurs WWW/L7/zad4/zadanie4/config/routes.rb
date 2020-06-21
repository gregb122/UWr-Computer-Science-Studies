Rails.application.routes.draw do
  root 'cars#index'
  resources :cars, only: [:index, :new, :create]
end
