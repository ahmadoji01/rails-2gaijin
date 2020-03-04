class Order
  include Mongoid::Document
  include SimpleEnum::Mongoid

  field :name, type: String
  field :email, type: String
  field :phone, type: String
  field :wechat, type: String

  field :shipping_date, type: DateTime
  field :price, type: Integer

  belongs_to :address, inverse_of: :order, autosave: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
 
  has_many :delivery_items, inverse_of: :order
  accepts_nested_attributes_for :delivery_items, reject_if: :all_blank, allow_destroy: true

  as_enum :status, :active => 1, :processed => 2, :complete => 3, :payment_received => 4, :inactive => 0
  as_enum :payment_method, :cod => 1

  belongs_to :user
  has_and_belongs_to_many :products, inverse_of: :order
end
