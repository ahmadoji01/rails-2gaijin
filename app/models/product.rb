class Product
  include Mongoid::Document
  include Mongoid::Search
  include SimpleEnum::Mongoid

  paginates_per 16

  field :name, type: String
  field :description, type: String
  field :price, type: Integer
  field :created_at, type: DateTime
  field :updated_at, type: DateTime
  field :latitude, type: BigDecimal
  field :longitude, type: BigDecimal
  
  as_enum :status, :active => 1, :inactive => 0, :sold => 2
  
  mount_uploader :image, ProductImageUploader
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :orders
  belongs_to :user
  has_and_belongs_to_many :delivery
  has_many :comments
  has_many :tags

  search_in :name, :price, :created_at, :status_cd, tags: :name, categories: :name
end
