class Product
  include Mongoid::Document
  include SimpleEnum::Mongoid
  searchkick

  paginates_per 8

  field :name, type: String
  field :description, type: String
  field :price, type: Integer
  field :created_at, type: DateTime
  field :updated_at, type: DateTime
  
  as_enum :status, :active => 1, :inactive => 0, :sold => 2
  
  mount_uploader :image, ProductImageUploader
  has_one :product_location
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :orders
  belongs_to :user
  has_and_belongs_to_many :delivery
end
