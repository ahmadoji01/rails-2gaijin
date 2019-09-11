class Notification
  include Mongoid::Document
  include SimpleEnum::Mongoid

  field :name, type: String
  field :created_at, type: DateTime
end
