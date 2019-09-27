class DeliveryItem
  include Mongoid::Document
  include SimpleEnum::Mongoid

  field :name, type: String
  field :address, type: String
  field :latitude, type: BigDecimal
  field :longitude, type: BigDecimal
  
  belongs_to :delivery

end
