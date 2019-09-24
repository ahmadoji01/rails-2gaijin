class Notification
  include Mongoid::Document
  include SimpleEnum::Mongoid

  field :name, type: String
  field :created_at, type: DateTime

  as_enum :status, :read => 1, :unread => 0
  as_enum :type, :comment => 1

  belongs_to :user
  belongs_to :product
  belongs_to :comment

end
