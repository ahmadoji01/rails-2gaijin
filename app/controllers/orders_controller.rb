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
    if @delivery.delivery_items.count == 0
      @delivery_items = DeliveryItem.new
    else
      @delivery_items = @delivery.delivery_items
    end
    @items_price = items_price(@delivery)
    @service_charge = @items_price * 0.15
    @total_price = @items_price + @service_charge
  end

  # GET /deliveries/1/edit
  def edit
    @delivery = active_delivery
  end

  def add_to_delivery
    if user_signed_in?
      @product = Product.find(params[:id])

      @delivery = Order.where(:status_cd => 1, buyer_id: current_user.id)[0]

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

    @delivery = Order.where(:status_cd => 1, buyer_id: current_user.id)[0]

    if @delivery.products.delete(@product)
      render json: "success".to_json
    end
  end

  def checkout
    @delivery = active_delivery
    @delivery.products.each do |product|
      order_product = OrderProduct.new
      order_product.order = @delivery
      order_product.product = product
      order_product.seller = product.user
      order_product.status = :open
      order_product.save
      time = @delivery.shipping_date.strftime("%Y-%m-%d %H:%M")
      send_item_order_notif(order_product.order.buyer, @delivery, time)
    end

    @delivery.update_attribute(:status_cd, 5)
    redirect_to user_delivery_url + "#deliverySuccess"
  end

  # POST /deliveries
  # POST /deliveries.json
  def create
    @delivery = Order.new(delivery_params)
    @delivery.buyer = current_user
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
    @delivery.buyer = current_user
    if @delivery.update(order_params)
      redirect_to review_order_url
    else
      render :edit
    end
  end

  def review
    @delivery = active_delivery
    @items_price = items_price(@delivery)
    @service_charge = @items_price * 0.15
    if @delivery.shipping_date == nil
      redirect_to order_delivery_url
    end
  end

  def submit_order
    @delivery = active_delivery
    @items_price = items_price(@delivery)
    if @delivery.shipping_date != nil
      @delivery.update_attribute(:status_cd, 2)
      @admins = User.where(:role_cd => 94)
      time = @delivery.shipping_date.strftime("%Y-%m-%d %H:%M")
      send_delivery_email(current_user, @admins, @delivery, time)
      Stripe::Checkout::Session.create({
        success_url: user_delivery_url + '#deliverySuccess',
        cancel_url: order_delivery_url,
        payment_method_types: ['card'],
        line_items: [
          {
            name: '2Gaijin Order #' + @delivery.id.to_s,
            description: 'Test Order',
            amount: @delivery.price,
            currency: 'jpy',
            quantity: 1,
          },
        ],
      })
      #redirect_to user_delivery_url + "#deliverySuccess"
    else
      redirect_to order_delivery_url
    end
  end

  # DELETE /deliveries/1
  # DELETE /deliveries/1.json
  def destroy
    @delivery.order_products.each do |orderproduct|
      orderproduct.destroy
    end
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
                                                                      link: user_item_order_path,
                                                                      image_url: product_image_url,
                                                                      time: notification.created_at,
                                                                      action: action
    end

  private

    def items_price(delivery)
      total_price = 0
      delivery.products.each do |product|
        total_price = total_price + product.price
      end
      return total_price
    end

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
        delivery = Order.where(:buyer_id => current_user.id, :status_cd => 1)
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
          delivery.buyer = current_user
          delivery.status = :active
          
          if delivery.save
            return delivery
          end
        end
      end
    end

    def send_item_order_notif(buyer, order, time)
      if order.products.count > 0
        order.products.each do |product|
          @notification = Notification.create name: buyer.first_name + " ordered your " + product.name + " for " + time,
                                              created_at: DateTime.now,
                                              user: product.user,
                                              product: product,
                                              status: :unread,
                                              type: :order,
                                              orderer: buyer

          @notification.user.update_attribute :notif_read, false
          broadcast_notif(@notification, @notification.user, "Add")
          DeliveryMailer.new_item_from_delivery_order_email_later(order.id.to_s, product.id.to_s, which_room(order.buyer.id.to_s, product.user.id.to_s).id.to_s).deliver_later(wait: 1.second)
        end
      end
    end

    def send_delivery_email(user, admins, delivery, time)
      user.update_attribute :phone, delivery.phone
      if delivery.wechat != ""
        user.update_attribute :wechat, delivery.wechat
      end
      delivery.address.update_attribute(:is_primary, true)
      if delivery.products.count > 0
        delivery.products.each do |product|
          @notification = Notification.create name: user.first_name + " ordered your " + product.name + " for " + time,
                                              created_at: DateTime.now,
                                              user: product.user,
                                              product: product,
                                              status: :unread,
                                              type: :order,
                                              orderer: user

          @notification.user.update_attribute :notif_read, false
          broadcast_notif(@notification, @notification.user, "Add")
          DeliveryMailer.new_item_from_delivery_order_email_later(delivery.id.to_s, product.id.to_s, which_room(delivery.buyer.id.to_s, product.user.id.to_s).id.to_s).deliver_later(wait: 1.second)
        end
      end

      if admins.count > 0
        admins.each do |admin|
          if user != admin
            @notification = Notification.create name: "Delivery order from " + user.first_name + " for " + time,
                                              created_at: DateTime.now,
                                              user: admin,
                                              status: :unread,
                                              type: :delivery,
                                              orderer: user

            @notification.user.update_attribute :notif_read, false
            broadcast_notif(@notification, @notification.user, "Add")
            DeliveryMailer.new_delivery_email_admin_later(delivery.id.to_s, admin.id.to_s, which_room(delivery.buyer.id.to_s, admin.id.to_s).id.to_s).deliver_later(wait: 1.second)
          end
        end
      end
      DeliveryMailer.new_delivery_email_later(delivery.id.to_s).deliver_later(wait: 1.second)
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
      params.require(:order).permit(:name, :email, :phone, :wechat, :shipping_date, :price, :payment_method, :status_cd,
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

