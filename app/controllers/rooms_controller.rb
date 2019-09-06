class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entities

  def index
    @rooms = Room.where(:user_ids => current_user.id)
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

  def contact_seller
    @seller_user = User.find(id: params[:seller_id])
    @buyer_user = User.find(id: current_user.id)

    @room = Room.find_by(room_type_cd: 0, user_ids: [@buyer_user.id, @seller_user.id])
    if @room.present?
      redirect_to @room
    else
      @newroom = Room.new
      @newroom.room_type = :private
      @newroom.name = @buyer_user.first_name + " - " + @seller_user.first_name
      @newroom.users << @buyer_user
      @newroom.users << @seller_user
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
