class CheckoutController < ApplicationController
  
  def create
  	@order = Order.find(id: params[:id])
  	@price = params[:price]

  	if @order.nil?
  	  redirect_to root_path
  	end

  	@session = Stripe::Checkout::Session.create(
  		payment_method_types: ['card'],
  		line_items: [{
  			name: "Order #" + @order.id.to_s,
  			description: "Checkout for order",
  			amount: @order.price,
  			currency: 'jpy',
  			quantity: 1
  		}],
  		success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}&order_id=" + @order.id.to_s,
  		cancel_url: checkout_cancel_url
  	)

  	respond_to do |format|
  	  format.js 	
  	end
  end

  def create_source
    @order = Order.find(id: params[:id])
    @price = params[:price]

    if @order.nil?
      redirect_to root_path
    end

    @source = Stripe::Source.create({
      type: 'wechat',
      amount: @order.price,
      currency: 'jpy',
      owner: {
        email: current_user.email,
      },
    })

    respond_to do |format|
      format.html   
    end
  end

  def source_charge
    @order = Order.find(id: params[:order_id])
    @source = Stripe::Source.retrieve(params[:id])
    @price = params[:price]

    if @source.nil?
      redirect_to review_order_url
    elsif @source.status != "chargeable"
      redirect_to create_source_url(id: params[:order_id], price: @price)
    end

    charge = Stripe::Charge.create({
      amount: @price,
      currency: 'jpy',
      source: @source.id.to_s,
    })

    @order.update_attribute(:status_cd, 2)
    redirect_to user_delivery_url + "#deliverySuccess"
  end

  def success
    @order = Order.find(id: params[:order_id])
    @order.update_attribute(:status_cd, 2)
    redirect_to user_delivery_url + "#deliverySuccess"
  end

  def cancel
    redirect_to review_order_url
  end

  def source_success
  end

  private 

  	def items_price(delivery)
      total_price = 0
      delivery.products.each do |product|
        total_price = total_price + product.price
      end
      return total_price
    end

  	def active_delivery
      if user_signed_in?
        delivery = Order.where(:user_id => current_user.id, :status_cd => 1)
        address = Address.where(:user_id => current_user.id, :is_primary => true)

        if address.present?
          address = address.first
        else
          address = Address.new
          address.buyer = current_user
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
end
