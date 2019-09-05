class Room
  include Mongoid::Document
  field :name, type: String

  has_many :room_messages, dependent: :destroy,
                         inverse_of: :room
end
