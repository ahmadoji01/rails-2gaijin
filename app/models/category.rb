class Category
  include Mongoid::Document

  field :name, type: String
  field :description, type: String
  field :created_at, type: Time
  field :updated_at, type: Time

  has_and_belongs_to_many :products
end
