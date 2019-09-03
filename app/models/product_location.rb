class ProductLocation
  include Mongoid::Document
  field :product_id, type: Integer
  field :latitude, type: Float
  field :longitude, type: Float
  belongs_to :product
end
