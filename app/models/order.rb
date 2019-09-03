class Order
  include Mongoid::Document
  include SimpleEnum::Mongoid

  field :user_id, type: Integer
  field :total_price, type: Integer
  field :created_at, type: Time
  field :updated_at, type: Time

  as_enum :shipping_method, :self => 0, :gaijindelivery => 1
  as_enum :status, :active => 1, :inactive => 0, :sold => 2

  belongs_to :user
  has_and_belongs_to_many :products
end
