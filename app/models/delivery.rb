class Delivery
  include Mongoid::Document
  include SimpleEnum::Mongoid

  field :name, type: String
  field :email, type: String
  field :phone, type: String

  field :delivery_date, type: DateTime
  field :price, type: Integer

  belongs_to :address, inverse_of: :delivery, autosave: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
 
  has_many :delivery_items, inverse_of: :delivery
  accepts_nested_attributes_for :delivery_items, reject_if: :all_blank, allow_destroy: true

  as_enum :status, :active => 1, :processed => 2, :complete => 3, :inactive => 0 

  belongs_to :user
  has_and_belongs_to_many :products, inverse_of: :delivery
end
