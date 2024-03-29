class Category
  include Mongoid::Document
  include Mongoid::Ancestry
  has_ancestry

  field :name, type: String

  has_and_belongs_to_many :products
end
