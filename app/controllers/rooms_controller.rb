class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entities
  before_action :authorized_user, except: [:index, :create, :update, :destroy, :contact_seller, :show]

  def index
    
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new permitted_parameters
    @room.last_active = DateTime.now
    @room.is_read = false
    @room.users << current_user

    if @room.save
      flash[:success] = "Room #{@room.name} was created successfully"
      redirect_to rooms_path
    else
      render :new
    end
    broadcast_room_notif
  end

  def edit
  end

  def contact_seller
    if params.has_key?(:notification_id)
      notif = Notification.find(id: params[:notification_id])
      if notif.unread?
        notif.update_attribute :status, :read
      end
    end

    if params.has_key?(:product_id)
      @product = Product.find(id: params[:product_id])
      ahoy.track "Clicked Chat with Seller from Product Page", id: @product.id.to_s
    end
    
    @seller_user = User.find(id: params[:seller_id])
    @buyer_user = User.find(id: current_user.id)

    @room1 = Room.where(user_ids: [@buyer_user.id, @seller_user.id])
    @room2 = Room.where(user_ids: [@seller_user.id, @buyer_user.id])

    if @room1.present?
      if @product.present?
        generate_product_link_msg(@seller_user, current_user, @room1.first, @product)
      end
      redirect_to @room1.first
    elsif @room2.present?
      if @product.present?
        generate_product_link_msg(@seller_user, current_user, @room2.first, @product)
      end
      redirect_to @room2.first
    else
      @newroom = Room.new
      @newroom.room_type = :private
      @newroom.name = @buyer_user.first_name + " - " + @seller_user.first_name
      @newroom.users << @buyer_user
      @newroom.users << @seller_user
      @newroom.last_active = DateTime.now
      if @newroom.save
        if @product.present?
          generate_product_link_msg(@seller_user, current_user, @newroom, @product)
        end
        flash[:success] = "Room #{@newroom.name} was created successfully"
        redirect_to @newroom
      else
        redirect_to root_path
      end
    end
  end

  def update
    if @room.update_attributes(permitted_parameters)
      flash[:success] = "Room #{@room.name} was updated successfully"
      redirect_to rooms_path
    else
      render :new
    end
  end

  def show
    if @room.users.map(&:id).include?(current_user.id)
      @room.update_attribute(:is_read, true)
      
      @last_message = @room.room_messages.order(created_at: :desc).first
      if @last_message.present?
        if !@last_message.readers.include?(current_user)
          @last_message.readers << current_user
          @last_message.update
        end
      end

      @room_message = RoomMessage.new room: @room
      @room_messages = @room.room_messages.includes(:user)
      broadcast_room_notif(@room)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  protected

  def count_unread_rooms(user)
    unreadrooms = Room.where(:user_ids => current_user.id)
    counter = 0

    unreadrooms.each do |room|
      if room.room_messages?
        if room.room_messages.order(created_at: :desc).first.reader_ids.include?(user.id)
          counter = counter + 1
        end
      end
    end

    return counter
  end

  def broadcast_room_notif(room)
    room.users.each do |user|
      if user != current_user
        user.update_attribute :message_read, false
        ActionCable.server.broadcast "room_notifications_channel_#{user.id}", unreadrooms: count_unread_rooms(user)
      end
    end
  end

  def load_entities
    @rooms = Room.where(:user_ids => current_user.id).order_by(last_active: :desc)
    @room = Room.find(params[:id]) if params[:id]
  end

  def user_involved
    params[:id]
  end

  def permitted_parameters
    params.require(:room).permit(:name, :room_type, :seller_id)
  end

  private

  def generate_product_link_msg(receiver, sender, room, product)
    message = product.name
    initmessage = "<a style='color: orange;' target='_blank' href='" + product_url(product) + "'>" + message + " <i class='fas fa-external-link-alt'></i></a>"
    room_message = RoomMessage.create user: sender,
                                     room: room,
                                     message: initmessage,
                                     created_at: DateTime.now
    room_message.readers << sender
    room_message.update
    RoomChannel.broadcast_to room, room_message
    NewsletterMailer.new_message_later(receiver.id.to_s, sender.id.to_s, room.id.to_s, message).deliver_later(wait: 1.second) if !receiver.online?
    if !receiver.online?
      receiver.update_attribute :message_read, false
      ActionCable.server.broadcast "room_notifications_channel_#{receiver.id}", unreadrooms: count_unread_rooms(receiver),
                                                                            roomid: room.id.to_s, 
                                                                            roompath: room_url(room),
                                                                            roomname: receiver.first_name,
                                                                            avatar: user_avatar_thumb(sender),
                                                                            time: DateTime.now
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

  def user_avatar_thumb(user)
    if user.avatar.thumb.present?
      return user.avatar.thumb.url
    else
      return ActionController::Base.helpers.image_url("avatar/avatar-1.png")
    end
  end

  def authorized_user
    if user_signed_in?
      if current_user.role != :admin
        raise ActionController::RoutingError.new('Not Found')
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end 

end
