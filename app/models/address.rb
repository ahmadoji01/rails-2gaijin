class Address
  include Mongoid::Document

  field :full_address, type: String
  field :apartment, type: String
  field :city, type: String
  field :state, type: String
  field :postal_code, type: String

  field :is_primary, type: Boolean

  belongs_to :user
end
