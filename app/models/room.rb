class Room
  include Mongoid::Document
  include SimpleEnum::Mongoid

  field :name, type: String
  field :is_read, type: Boolean
  field :last_active, type: DateTime

  as_enum :room_type, :private => 0, :group => 1, :public => 2

  has_many :room_messages, dependent: :destroy, inverse_of: :room
  has_and_belongs_to_many :users
end
