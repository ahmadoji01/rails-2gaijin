class UserAddress
  include Mongoid::Document
  field :user_id, type: Integer
  field :address, type: String
  field :city, type: String
  field :state, type: String
  field :postal_code, type: String
  field :created_at, type: Time
  field :updated_at, type: Time

  belongs_to :user
end
