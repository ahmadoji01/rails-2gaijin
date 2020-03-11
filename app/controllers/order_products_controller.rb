class OrderProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorized_user, except: [:create, :update, :destroy, :order_delivery, :add_to_delivery, :remove_from_delivery]
  
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
  	allconfirmed = true

  	@order.order_products.each do |orderproduct|
  	  if !orderproduct.confirmed?
  	  	allconfirmed = false
  	  end
  	end

  	if allconfirmed
  	  issue_payment
  	  @order.update_attribute(:status_cd, 7)
  	end

  end

  private
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