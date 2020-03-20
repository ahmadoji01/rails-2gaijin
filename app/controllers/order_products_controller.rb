class OrderProductsController < ApplicationController
  before_action :authenticate_user!
  
  def confirm_order
  	@orderproduct = OrderProduct.find(id: params[:id])
  	@orderproduct.update_attribute(:status_cd, 2)

  	@otherorders = OrderProduct.where(product: @orderproduct.product)
  	
  	@otherorders.each do |order|
  	  if order != @orderproduct
  	  	order.update_attribute(:status_cd, 3)
  	  end
  	end

  	@order = @orderproduct.order

  	if order_confirmed?(@order)
      issue_payment
      @order.update_attribute(:status_cd, 7)
    else
      @order_transporter.update_attribute(:status_cd, 4)
    end
    redirect_to user_item_order_path
  end

  def accept_delivery
    order = Order.find(params[:id])
    transporter = User.find(params[:transporter_id])
    
    all_order_transporters = OrderTransporter.where(order_id: order.id)
    order_transporter = OrderTransporter.where(order_id: order.id, transporter_id: transporter.id).first
    if order.transporter.nil?
      order.update_attribute(:transporter, transporter)
      order_transporter.update_attribute(:status_cd, 2)
      delivery_offer_taken(all_order_transporters, transporter)
      if order_confirmed?(order)
        issue_payment
        order.update_attribute(:status_cd, 7)
      else
        order_transporter.update_attribute(:status_cd, 4)
      end
      redirect_to user_delivery_offer_url + "#offerAccepted"
    else
      redirect_to user_delivery_offer_url + "#offerAccepted"
    end

  end

  def reject_delivery
    order = Order.find(params[:id])
    transporter = User.find(params[:transporter_id])
    
    order_transporter = OrderTransporter.where(order_id: order.id, transporter_id: transporter.id).first
    order_transporter.update_attribute(:status_cd, 3)
    
    redirect_to user_delivery_offer_url  + "#offerRejected"
  end

  private

  def delivery_offer_taken(offers, transporter)
    offers.each do |offer|
      if !offer.transporter == transporter
        offer.update_attribute(:status_cd, 5)
      end
    end
  end

  def notify_transporter(transporter)
  end

  def notify_seller(seller)
  end

  def order_confirmed?(order)
    allconfirmed = true

    if order.transporter.nil?
      allconfirmed = false
      return allconfirmed
    end

    order.order_products.each do |orderproduct|
      if !orderproduct.confirmed?
        allconfirmed = false
        return allconfirmed
      end
    end

    return allconfirmed
  end

	def issue_payment
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