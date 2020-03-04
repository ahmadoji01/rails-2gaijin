class Address
  include Mongoid::Document

  field :full_address, type: String
  field :apartment, type: String
  field :city, type: String
  field :state, type: String
  field :postal_code, type: String

  field :is_primary, type: Boolean

  field :latitude, type: BigDecimal
  field :longitude, type: BigDecimal

  belongs_to :user
  has_many :orders
  has_many :jobs_applications
end
