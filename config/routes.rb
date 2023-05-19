Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v0 do
      get '/markets/search', to: 'markets#search'
      get '/markets/:id/nearest_atms', to: 'markets#nearest_atms'
      resources :market_vendors, only: [:create]
      resources :markets do
        resources :vendors, only: [:index]
      end
      resources :vendors, only: [:show, :create, :update, :destroy]
      delete '/market_vendors', to: 'market_vendors#destroy'
    end
  end
end
