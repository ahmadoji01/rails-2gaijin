class OrdersController < ApplicationController
  before_action :set_delivery, only: [:show, :edit, :update, :order_delivery, :destroy]
  before_action :authenticate_user!
  before_action :authorized_user, except: [:create, :update, :destroy, :order_delivery, :add_to_delivery, :remove_from_delivery]
  invisible_captcha only: [:update]
  before_action :send_cancel_email, only: [:destroy]

  # GET /deliveries
  # GET /deliveries.json
  def index
    @deliveries = Order.all
  end

  # GET /deliveries/1
  # GET /deliveries/1.json
  def show
  end

  # GET /deliveries/new
  def new
    @delivery = Order.new
  end

  def order_delivery
    @delivery = active_delivery
  end

  # GET /deliveries/1/edit
  def edit
    @delivery = active_delivery
  end

  def add_to_delivery
    if user_signed_in?
      @product = Product.find(params[:id])

      @delivery = Order.where(:status_cd => 1, user_id: current_user.id)[0]

      @delivery.products << @product
      if @delivery.update
        render json: "success".to_json
      end
    else
      render json: "failed".to_json
    end
  end

  def remove_from_delivery
    @product = Product.find(params[:id])

    @delivery = Order.where(:status_cd => 1, user_id: current_user.id)[0]

    if @delivery.products.delete(@product)
      render json: "success".to_json
    end
  end

  def checkout
    @delivery = Order.new(delivery_params)
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
    @delivery = Order.new(delivery_params)
    @delivery.user = current_user
    @delivery.address.user = current_user

    address = Address.where(:user_id => current_user.id, :is_primary => true)

    if address.present?
      address = address.first
    else
      address = Address.new
      address.user = current_user
    end

    respond_to do |format|
      if @delivery.save
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
    @admins = User.where(:role_cd => 94)
    time = Time.parse(params[:order][:shipping_date]).strftime("%Y-%m-%d %H:%M")

    if @delivery.update(order_params)
      current_user.update_attribute :phone, params[:order][:phone]
      if params[:order][:wechat] != ""
        current_user.update_attribute :wechat, params[:order][:wechat]
      end
      @delivery.address.update_attribute(:is_primary, true)
      if @delivery.products.count > 0
        @delivery.products.each do |product|
          @notification = Notification.create name: current_user.first_name + " ordered your " + product.name + " for " + time,
                                              created_at: DateTime.now,
                                              user: product.user,
                                              product: product,
                                              status: :unread,
                                              type: :order,
                                              orderer: current_user

          @notification.user.update_attribute :notif_read, false
          broadcast_notif(@notification, @notification.user, "Add")
          DeliveryMailer.new_item_from_delivery_order_email_later(@delivery.id.to_s, product.id.to_s, which_room(@delivery.user.id.to_s, product.user.id.to_s).id.to_s).deliver_later(wait: 1.second)
        end
      end

      if @admins.count > 0
        @admins.each do |admin|
          if current_user != admin
            @notification = Notification.create name: "Delivery order from " + current_user.first_name + " for " + time,
                                              created_at: DateTime.now,
                                              user: admin,
                                              status: :unread,
                                              type: :delivery,
                                              orderer: current_user

            @notification.user.update_attribute :notif_read, false
            broadcast_notif(@notification, @notification.user, "Add")
            DeliveryMailer.new_delivery_email_admin_later(@delivery.id.to_s, admin.id.to_s, which_room(@delivery.user.id.to_s, admin.id.to_s).id.to_s).deliver_later(wait: 1.second)
          end
        end
      end
      DeliveryMailer.new_delivery_email_later(@delivery.id.to_s).deliver_later(wait: 1.second)
      redirect_to user_delivery_url + "#deliverySuccess"
    else
      render :edit
    end
  end

  # DELETE /deliveries/1
  # DELETE /deliveries/1.json
  def destroy
    @delivery.destroy
    respond_to do |format|
      format.html { redirect_to user_delivery_url + "#deliveryRemoved", notice: 'Delivery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  protected
    def send_cancel_email
      @admins = User.where(:role_cd => 94)
      if @admins.count > 0
        @admins.each do |admin|
          if current_user != admin
            DeliveryMailer.cancel_delivery_admin_later(current_user.id.to_s, admin.id.to_s, which_room(current_user.id.to_s, admin.id.to_s).id.to_s).deliver_later(wait: 1.second)
          end
        end
      end
    end

    def count_unread_notifs(user)
      Notification.where(:status_cd => 0).and(:user_id => user.id).length
    end

    def broadcast_notif(notification, user, action)

      product_image_url = ""

      if notification.product.present?
        if notification.product.product_images.present?
          product_image_url = notification.product.product_images[0].image.url(:thumb)
        else
          product_image_url = ActionController::Base.helpers.image_url("products/product-1-50.png")
        end
      else
        product_image_url = ActionController::Base.helpers.image_url("products/product-1-50.png")
      end

      NotificationChannel.broadcast_to user, notification
      ActionCable.server.broadcast "notification_channel_#{user.id}", unreadnotifs: count_unread_notifs(user),
                                                                      notifid: notification.id.to_s, 
                                                                      name: notification.name, 
                                                                      link: contact_seller_rooms_path(seller_id: notification.orderer.id, notification_id: notification.id),
                                                                      image_url: product_image_url,
                                                                      time: notification.created_at,
                                                                      action: action
    end

  private

    def which_room(first_user_id, second_user_id)
      first_user = User.find(id: first_user_id)
      second_user = User.find(id: second_user_id)

      room1 = Room.where(user_ids: [first_user.id, second_user.id])
      room2 = Room.where(user_ids: [second_user.id, first_user.id])

      if room1.present?
        return room1.first
      elsif room2.present?
        return room2.first
      else
        newroom = Room.new
        newroom.room_type = :private
        newroom.name = first_user.first_name + " - " + second_user.first_name
        newroom.users << first_user
        newroom.users << second_user
        newroom.last_active = DateTime.now
        newroom.save
        return newroom
      end
    end

    def active_delivery
      if user_signed_in?
        delivery = Order.where(:user_id => current_user.id, :status_cd => 1)
        address = Address.where(:user_id => current_user.id, :is_primary => true)

        if address.present?
          address = address.first
        else
          address = Address.new
          address.user = current_user
        end
        
        if delivery.present?
          delivery = delivery.first
          delivery.address = address
          return delivery
        else
          delivery = Order.new

          delivery.address = address
          delivery.user = current_user
          delivery.status = :active
          
          if delivery.save
            return delivery
          end
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_delivery
      if params.has_key?(:id)
        @delivery = Order.find(params[:id])
      else
        @delivery = active_delivery
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :email, :phone, :wechat, :shipping_date, :price, :payment_method,
                                       address_attributes: [:id, :full_address, :apartment, :city, :state, :postal_code, :user_id, :latitude, :longitude],
                                       delivery_items_attributes: [:id, :name, :address, :size])
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

