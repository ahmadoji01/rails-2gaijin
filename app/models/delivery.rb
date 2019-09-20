class Delivery
  include Mongoid::Document
  include SimpleEnum::Mongoid

  field :name, type: String
  field :email, type: String
  field :phone, type: String

  field :delivery_date, type: DateTime
  field :price, type: Integer

  has_one :destination, :class_name => "Address"

  has_many :delivery_items, inverse_of: :delivery
  accepts_nested_attributes_for :delivery_items, reject_if: :all_blank, allow_destroy: true

  as_enum :status, :active => 1, :processed => 2, :complete => 3, :inactive => 0 

  belongs_to :user
end
