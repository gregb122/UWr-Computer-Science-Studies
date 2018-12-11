Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'home/json', to: 'home#json', as: "json_type"
  get 'home/html', to: 'home#html', as: "html_type" 
  get 'home/text', to: 'home#text', as: "text_type"
  get 'home/xml', to: 'home#xml', as: "xml_type"
  get 'home/index',to: 'home#index', as: "index"
  root 'home#index'
end
