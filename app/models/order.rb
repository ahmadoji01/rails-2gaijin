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

  as_enum :status, :active => 1, :processed => 2, :complete => 3, :payment_received => 4, :waiting_confirmation => 5, :rejected => 6, :waiting_payment => 7, :inactive => 0
  as_enum :payment_method, :cod => 1, :wechat => 2, :card => 3
  as_enum :delivery_method, :delivery_2gaijin => 1, :handover => 2

  belongs_to :buyer, :class_name => "User", inverse_of: :order
  has_and_belongs_to_many :products, inverse_of: :order
  belongs_to :transporter, :class_name => "User", optional: true

  has_many :order_products, inverse_of: :order
  has_many :order_transporters, inverse_of: :order
end
