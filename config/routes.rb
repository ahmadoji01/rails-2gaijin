Rails.application.routes.draw do
  
  get 'about_us', :to => 'infos#about_us'
  get 'terms_and_conditions', :to => 'infos#terms'
  get 'delivery_pricing', :to => 'infos#delivery_pricing'
  get 'contact_us', :to => 'tickets#new'
  get '/en/register' => redirect('/')

  mount RailsAdmin::Engine => '/dashboard', as: 'rails_admin'
  mount Ckeditor::Engine => '/ckeditor'
  mount Ahoy::Engine => "/ahoy", as: :my_ahoy

  resources :orders
  resources :addresses do
    collection do
      post 'set_primary'
    end
  end

  resources :categories
  get 'category/add'
  
  get '/search', :to => 'search#index', :as => 'search_page'

  resources :room_messages
  resources :rooms do
    collection do
      post 'contact_seller'
    end
  end

  resources :notifications
  resources :products
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords', omniauth_callbacks: 'users/omniauth_callbacks' }, path: '', path_names: { sign_in: "login", sign_out: "logout" }
  root "home#index"

  resource :products do
    collection do
      post 'mark_as_sold'
      post 'unfollow'
    end
  end

  resource :notifications do
    collection do
      post 'set_message_read'
      post 'set_notif_read'
      post 'email_subscription'
    end
  end

  resources :deliveries do
    member do
      get :delete
      post 'add_to_delivery'
      post 'remove_from_delivery'
    end
  end

  resources :comments
  resources :tickets

  as :user do
  	get 'profile', :to => 'users/registrations#edit', :as => :user_root
    get 'listed_product', :to => 'users/registrations#edit_product', :as => :user_product
    get 'shipping_address', :to => 'users/registrations#edit_address', :as => :user_address
    get 'delivery_order', :to => 'users/registrations#edit_delivery', :as => :user_delivery
  end

  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
