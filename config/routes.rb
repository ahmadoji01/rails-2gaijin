Rails.application.routes.draw do
  
  get 'about_us', :to => 'infos#about_us'
  get 'terms_and_conditions', :to => 'infos#terms'
  get 'delivery_pricing', :to => 'infos#delivery_pricing'
  get 'job_app_terms_conditions', :to => 'infos#job_app_terms_conditions'
  get 'contact_us', :to => 'tickets#new'
  get 'apply_for_job', :to => 'jobs_applications#new'
  #get 'loaderio-5fff137063d23362ea7c8793a61bad99', :to => 'home#loaderio' 
  get '/en/register' => redirect('/')

  mount RailsAdmin::Engine => '/dashboard', as: 'rails_admin'
  mount Ckeditor::Engine => '/ckeditor'
  mount StripeEvent::Engine, at: '/stripe-webhooks'

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

  resources :jobs_applications

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

  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'checkout_create'
    post 'create_source', to: 'checkout#create_source', as: 'checkout_create_source'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
    get 'success', to: 'checkout#success', as: 'checkout_success'
    post 'source_charge', to: 'checkout#source_charge', as: 'checkout_source_charge'
  end

  resources :orders do
    member do
      get :delete
    end
  end
  get 'order_delivery' => "orders#order_delivery"
  post 'order_delivery' => "orders#order_delivery"
  get 'review_order' => "orders#review"
  post 'review_order' => "orders#review"
  get 'submit_order' => "orders#submit_order"
  post 'submit_order' => "orders#submit_order"
  post 'add_to_delivery' => "orders#add_to_delivery"
  post 'remove_from_delivery' => "orders#remove_from_delivery"
  post 'checkout_order' => "orders#checkout"

  post 'confirm_order' => "order_products#confirm_order"
  post 'accept_delivery' => "order_products#accept_delivery"
  post 'reject_delivery' => "order_products#reject_delivery"

  resources :comments
  resources :tickets
  resources :wallets

  as :user do
  	get 'profile', :to => 'users/registrations#edit', :as => :user_root
    get 'listed_product', :to => 'users/registrations#edit_product', :as => :user_product
    get 'shipping_address', :to => 'users/registrations#edit_address', :as => :user_address
    get 'delivery_order', :to => 'users/registrations#edit_delivery', :as => :user_delivery
    get 'applied_job', :to => 'users/registrations#edit_job_application', :as => :user_job_app
    get 'item_order', :to => 'users/registrations#edit_item_order', :as => :user_item_order
    get 'delivery_offer', :to => 'users/registrations#edit_delivery_offer', :as => :user_delivery_offer
  end

  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
