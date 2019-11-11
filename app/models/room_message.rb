class RoomMessage
  include Mongoid::Document
  field :message, type: String
  field :created_at, type: DateTime

  belongs_to :user
  belongs_to :room, inverse_of: :room_messages

  has_and_belongs_to_many :readers, :class_name => "User", :inverse_of => :read_messages

  def as_json(options)
  	super(options).merge(user_avatar_url: user_avatar_thumb(user))
  end

  private

  def user_avatar_thumb(user)
    if user.avatar.thumb.present?
      return user.avatar.thumb.url
    else
      return "avatar/avatar-1.png"
    end
  end
  
end
