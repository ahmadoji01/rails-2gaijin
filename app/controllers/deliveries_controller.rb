class DeliveriesController < ApplicationController
  before_action :set_delivery, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /deliveries
  # GET /deliveries.json
  def index
    @deliveries = Delivery.all
  end

  # GET /deliveries/1
  # GET /deliveries/1.json
  def show
  end

  # GET /deliveries/new
  def new
    @delivery = Delivery.new
  end

  # GET /deliveries/1/edit
  def edit
  end

  def add_to_delivery
    @product = Product.find(params[:id])

    @delivery = Delivery.where(:status_cd => 1, user_id: current_user.id)[0]

    @delivery.products << @product
    if @delivery.update
      sweetalert_success('Product has successfully been added to the delivery', 'Successfully Added', button: 'Awesome!')
      redirect_to @product
    end
  end

  def remove_from_delivery
    @product = Product.find(params[:id])

    @delivery = Delivery.where(:status_cd => 1, user_id: current_user.id)[0]

    if @delivery.products.delete(@product)
      sweetalert_success('Product has successfully been removed to the delivery', 'Successfully Removed', button: 'Awesome!')
      redirect_to @product
    end
  end

  def checkout
    @delivery = Delivery.new(delivery_params)
    @delivery.user = current_user

    respond_to do |format|
      if @delivery.save
        format.html { redirect_to @delivery, notice: 'Delivery was successfully created.' }
        format.json { render :show, status: :created, location: @delivery }
      else
        format.html { render :new }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /deliveries
  # POST /deliveries.json
  def create
    @delivery = Delivery.new(delivery_params)
    @delivery.user = current_user
    @delivery.address.user = current_user

    respond_to do |format|
      if @delivery.save
        sweetalert_success('Your order has been received and we will inform our member', 'Successfully ordered', button: 'Awesome!')
        format.html { redirect_to root_url, notice: 'Delivery was successfully created.' }
        format.json { render :show, status: :created, location: @delivery }
      else
        format.html { render :new }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deliveries/1
  # PATCH/PUT /deliveries/1.json
  def update
    @delivery.status = :processed

    @delivery.products.each do |product|
      @notification = Notification.create name: current_user.first_name + " ordered your " + product.name + " for " + params[:delivery][:delivery_date],
                                          created_at: DateTime.now,
                                          user: product.user,
                                          product: product,
                                          status: :unread,
                                          type: :order,
                                          orderer: current_user

      broadcast_notif(@notification, @notification.user, "Add")
    end

    respond_to do |format|
      if @delivery.update(delivery_params)
        sweetalert_success('Your order has been received and we will inform our member', 'Successfully ordered', button: 'Awesome!')
        format.html { redirect_to root_url, notice: 'Delivery was successfully updated.' }
        format.json { render :show, status: :ok, location: root_url }
      else
        format.html { render :edit }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deliveries/1
  # DELETE /deliveries/1.json
  def destroy
    @delivery.destroy
    respond_to do |format|
      format.html { redirect_to deliveries_url, notice: 'Delivery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  protected

    def count_unread_notifs(user)
      Notification.where(:status_cd => 0).and(:user_id => user.id).length
    end

    def broadcast_notif(notification, user, action)

      NotificationChannel.broadcast_to user, notification
      ActionCable.server.broadcast "notification_channel_#{user.id}", unreadnotifs: count_unread_notifs(user), 
                                                                      name: notification.name, 
                                                                      link: contact_seller_rooms_path(notification.user.id),
                                                                      action: action
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery
      @delivery = Delivery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def delivery_params
      params.require(:delivery).permit(:name, :email, :phone, :delivery_date, :price,
                                       address_attributes: [:full_address, :apartment, :city, :state, :postal_code, :latitude, :longitude],
                                       delivery_items_attributes: [:id, :name, :address, :size])
    end
end
