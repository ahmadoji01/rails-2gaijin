class Location
  include Mongoid::Document
  field :name, type: String
  field :latitude, type: BigDecimal
  field :longitude, type: BigDecimal
end
