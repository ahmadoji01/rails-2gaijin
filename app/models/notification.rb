class Notification
  include Mongoid::Document
  include SimpleEnum::Mongoid

  field :name, type: String
  field :created_at, type: DateTime

  as_enum :status, :read => 1, :unread => 0
  as_enum :type, :comment => 1, :order => 2

  belongs_to :user
  belongs_to :product
  belongs_to :comment, optional: true

  belongs_to :orderer, :class_name => "User", optional: true

end
