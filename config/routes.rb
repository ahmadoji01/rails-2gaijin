Rails.application.routes.draw do
  
  resources :orders
  resources :addresses do
    collection do
      post 'set_primary'
    end
  end

  resources :categories
  get 'category/add'
  
  get '/search', :to => 'search#index', :as => 'search_page'
  get '/dashboard', :to => 'dashboard#index'

  resources :room_messages
  resources :rooms do
    collection do
      post 'contact_seller'
    end
  end

  resources :notifications
  resources :products
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }, path: '', path_names: { sign_in: "login", sign_out: "logout" }
  root "home#index"
  resource :products

  as :user do
  	get 'profile', :to => 'users/registrations#edit', :as => :user_root
    get 'listed_product', :to => 'users/registrations#edit_product', :as => :user_product
    get 'shipping_address', :to => 'users/registrations#edit_address', :as => :user_address
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
