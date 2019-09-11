class RoomMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entities

  def create
    if(params.dig(:room_message, :message) != "")
      @room.update_attribute(:last_active, DateTime.now)
      @room.update_attribute(:is_read, false)
      @room_message = RoomMessage.create user: current_user,
                                         room: @room,
                                         message: params.dig(:room_message, :message),
                                         created_at: DateTime.now
                                         
      RoomChannel.broadcast_to @room, @room_message
      ActionCable.server.broadcast 'room_notifications_channel', unreadrooms: count_unread_rooms
    end
  end

  protected

  def count_unread_rooms
    unreadrooms = Room.where(:is_read => false).and(:user_ids => current_user.id).length
    return unreadrooms
  end

  def load_entities
    @room = Room.find params.dig(:room_message, :room_id)
  end
end
