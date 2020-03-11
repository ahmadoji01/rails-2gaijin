class Product
  include Mongoid::Document
  include Mongoid::Search
  include SimpleEnum::Mongoid

  field :name, type: String
  field :description, type: String
  field :price, type: Integer
  field :created_at, type: DateTime
  field :updated_at, type: DateTime
  
  field :latitude, type: BigDecimal
  field :longitude, type: BigDecimal
  field :location, type: Array  # [lat,lng]
  index( { location: '2d' }, { min: -180, max: 180 }) # create an special index 
  before_save :fix_location, if: :location_changed? # lat and lng must be in float format
  def fix_location
    self.location = self.location.map(&:to_f)
  end

  field :page_views, type: Integer
  
  as_enum :status, :active => 1, :inactive => 0, :sold => 2
  
  has_many :product_images
  accepts_nested_attributes_for :product_images

  has_many :order_products, inverse_of: :order

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :orders
  belongs_to :user
  has_many :comments
  has_many :tags

  has_and_belongs_to_many :followers, :class_name => "User", :inverse_of => :followed_products

  search_in :name, :price, :created_at, :status_cd, tags: :name, categories: :name

  scope :status, -> (status) { where status_cd: status.to_i }
  scope :user, -> (user) { where user_id: user.to_s }
  scope :minprice, -> (price) { where :price.gte => price }
  scope :maxprice, -> (price) { where :price.lte => price }
  
  scope :sortby, -> (sortby) { 
    if sortby.to_i == 1
      order price: :desc
    elsif sortby.to_i == 2
      order price: :asc
    elsif sortby.to_i == 3
      order created_at: :desc 
    elsif sortby.to_i == 4
      order created_at: :asc
    end           
  }

  scope :pricesort, -> (pricesort) { 
    if pricesort.to_i == 1
      order price: :desc
    elsif pricesort.to_i == 2
      order price: :asc
    end           
  }
  
  scope :datesort, -> (datesort) { 
    if datesort.to_i == 1
      order created_at: :desc 
    elsif datesort.to_i == 2
      order created_at: :asc
    end
  }
end
