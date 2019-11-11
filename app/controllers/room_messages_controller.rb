class RoomMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entities

  def create
    if(params.dig(:room_message, :message) != "")
      @room.update_attribute(:last_active, DateTime.now)
      @room_message = RoomMessage.create user: current_user,
                                         room: @room,
                                         message: params.dig(:room_message, :message),
                                         created_at: DateTime.now
      @room_message.readers << current_user
      @room_message.update

      RoomChannel.broadcast_to @room, @room_message

      @room.users.each do |user|
        if user != current_user
          #RoomNotificationsChannel.broadcast_to user, @room
          if !user.online?
            user.update_attribute :message_read, false
            ActionCable.server.broadcast "room_notifications_channel_#{user.id}", unreadrooms: count_unread_rooms(user),
                                                                                  roomid: @room.id.to_s, 
                                                                                  roompath: room_path(@room),
                                                                                  roomname: current_user.first_name,
                                                                                  avatar: user_avatar_thumb(current_user),
                                                                                  time: DateTime.now
            send_email(user, current_user, @room, @room_message.message)
          end
        end
      end
    end
  end

  protected

  def send_email(receiver, sender, room, message)
    if room.room_messages.count == 1
      NewsletterMailer.new_message_later(receiver.id.to_s, sender.id.to_s, room.id.to_s, message).deliver_later(wait: 1.seconds) if receiver.receive_email?
    elsif room.room_messages.count >= 2
      last_message_time = room.room_messages.order(created_at: :desc).first.created_at
      second_last_message_time = room.room_messages.order(created_at: :desc).second.created_at
      delta_time = ((last_message_time - second_last_message_time) * 24 * 60 * 60).to_i # in seconds
      if delta_time >= (3 * 60) # 3 minutes converted into seconds
        NewsletterMailer.new_message_later(receiver.id.to_s, sender.id.to_s, room.id.to_s, message).deliver_later(wait: 1.seconds) if receiver.receive_email?
      end
    end
  end

  def user_avatar_thumb(user)
    if user.avatar.thumb.present?
      return user.avatar.thumb.url
    else
      return ActionController::Base.helpers.image_url("avatar/avatar-1.png")
    end
  end

  def count_unread_rooms(user)
    unreadrooms = Room.where(:user_ids => user.id)
    counter = 0

    unreadrooms.each do |room|
      last_message = room.room_messages.order(created_at: :desc).first
      if last_message.present?
        if !last_message.reader_ids.include?(user.id)
            counter = counter + 1
        end
      end
    end

    return counter
  end

  def load_entities
    @room = Room.find params.dig(:room_message, :room_id)
  end
end
