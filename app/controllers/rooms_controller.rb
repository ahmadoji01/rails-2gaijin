class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entities

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
    @seller_user = User.find(id: params[:seller_id])
    @buyer_user = User.find(id: current_user.id)

    @room = Room.where(room_type_cd: 0, user_ids: [@buyer_user.id, @seller_user.id])
    if @room.present?
      redirect_to @room.first
    else
      @newroom = Room.new
      @newroom.room_type = :private
      @newroom.name = @buyer_user.first_name + " - " + @seller_user.first_name
      @newroom.users << @buyer_user
      @newroom.users << @seller_user
      @newroom.last_active = DateTime.now
      if @newroom.save
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
    @room.update_attribute(:is_read, true)
    @room_message = RoomMessage.new room: @room
    @room_messages = @room.room_messages.includes(:user)
    broadcast_room_notif
  end

  protected

  def count_unread_rooms
    unreadrooms = Room.where(:is_read => false).and(:user_ids => current_user.id).length
    return unreadrooms
  end

  def broadcast_room_notif
    ActionCable.server.broadcast 'room_notifications_channel', unreadrooms: count_unread_rooms
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

end
