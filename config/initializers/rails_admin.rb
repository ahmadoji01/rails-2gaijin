RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true
  config.main_app_name = ["2Gaijin on Rails", "Dashboard"]

  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  config.authorize_with do
    redirect_to main_app.root_path unless current_user.admin?
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Category' do
    field :name
    field :products
  end

  config.model 'Notification' do
    field :name
    field :created_at

    field :status, :enum do
      enum do
        { Read: "read", Unread: "unread"}
      end
    end
    field :type, :enum do
      enum do
        { Comment: "comment", Order: "order", Delivery: "delivery"}
      end
    end

    field :user
    field :product
    field :comment
    
    field :orderer
  end

  config.model 'User' do
    field :id
    ## Database authenticatable
    field :email
    field :password
    field :password_confirmation

    ## Rememberable
    field :remember_created_at
    field :first_name
    field :last_name
    field :slug
    field :date_of_birth
    field :phone
    field :role, :enum do
      enum do
        { Administrator: "admin", Subscriber: "user", Transporter: "transporter"}
      end
    end

    field :avatar

    field :provider
    field :uid

    field :addresses
    field :products
  end

  config.model 'Product' do
    field :name
    field :description, :ck_editor
    field :price
    field :status, :enum do
      enum do
        { Available: "active", Inactive: "inactive", Sold: "sold"}
      end
    end
    field :created_at
    field :updated_at
    field :location, :geospatial do
      google_api_key Rails.application.credentials.google_maps_api_key
      default_latitude 43.0772956  # Kiev, Ukraine
      default_longitude 141.3467105
      default_zoom_level 15
    end
    field :latitude
    field :longitude

    field :product_images
    field :categories

    field :user_id, :enum do
      enum do
        User.all.collect {|p| [p.email, p.id]}
      end
    end
  end

  config.model 'Order' do
    field :name
    field :email
    field :phone
    
    field :shipping_date
    field :price
    
    field :address

    field :delivery_items
    field :products

    field :payment_method, :enum do
      enum do
        { "Cash on Delivery": "cod" }
      end
    end

    field :status, :enum do
      enum do
        { Active: "active", "Payment Received": "payment_received", Processed: "processed", Complete: "complete", Inactive: "inactive"}
      end
    end

    field :user_id, :enum do
      enum do
        User.all.collect {|p| [p.first_name, p.id]}
      end
    end
  end

  config.model 'Ticket' do
    field :id
    field :name
    field :email
    field :content, :ck_editor
    field :created_at
  end
end
