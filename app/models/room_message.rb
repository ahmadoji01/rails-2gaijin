class RoomMessage
  include Mongoid::Document
  field :message, type: String
  field :created_at, type: DateTime

  belongs_to :user
  belongs_to :room, inverse_of: :room_messages

  def as_json(options)
  	super(options).merge(user_avatar_url: user.gravatar_url)
  end
  
end
