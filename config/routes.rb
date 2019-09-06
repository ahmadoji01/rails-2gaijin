Rails.application.routes.draw do
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
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
