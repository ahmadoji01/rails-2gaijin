class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entities

  def index
    @rooms = Room.where()
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new permitted_parameters
    @room.users << current_user

    if @room.save
      flash[:success] = "Room #{@room.name} was created successfully"
      redirect_to rooms_path
    else
      render :new
    end
  end

  def edit
  end

  def contact_seller_room

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
    @room_message = RoomMessage.new room: @room
    @room_messages = @room.room_messages.includes(:user)
  end

  protected

  def load_entities
    @rooms = Room.all
    @room = Room.find(params[:id]) if params[:id]
  end

  def permitted_parameters
    params.require(:room).permit(:name, :room_type, :seller_id)
  end

end
