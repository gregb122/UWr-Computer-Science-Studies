Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  resources :home, only: [:index]
  get 'contact', to: "home#contact", as: :contact
  get 'gallery', to: "home#gallery", as: :gallery

end
