class OrderProduct
  include Mongoid::Document
  include SimpleEnum::Mongoid

  belongs_to :product
  belongs_to :order
  belongs_to :seller, :class_name => "User"

  as_enum :status, :open => 1, :confirmed => 2, :rejected => 3
end
