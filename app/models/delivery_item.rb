class DeliveryItem
  include Mongoid::Document
  include SimpleEnum::Mongoid

  field :name, type: String

  as_enum :size, :big => 1, :small => 0

  field :address, type: String
  field :latitude, type: BigDecimal
  field :longitude, type: BigDecimal
  
  belongs_to :delivery

end
