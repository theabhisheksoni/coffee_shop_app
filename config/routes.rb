Rails.application.routes.draw do
  resources :discounts
  resources :tax_categories
  resources :orders, except: [:edit, :update]
  resources :items
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "items#index"
end
