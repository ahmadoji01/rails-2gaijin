class DeliveryMailer < ApplicationMailer
  def new_delivery_email
  	@delivery = Order.find(id: params[:order_id])
  	mail(to: @delivery.buyer.email, subject: "Here is the summary of your delivery order!")
  end

  def new_delivery_email_admin
  	@delivery = Order.find(id: params[:order_id])
  	@admins = User.admins
  	if @admins.count > 0
  		@admins.each do |admin|
  			mail(to: admin.email, subject: "Delivery order incoming!")
  		end
  	end
  end

  def new_delivery_email_later(orderid)
    @delivery = Order.find(id: orderid)
    mail(to: @delivery.buyer.email, subject: "Here is the summary of your delivery order!")
  end

  def new_item_from_delivery_order_email_later(orderid, productid, roomid)
    @delivery = Order.find(id: orderid)
    @product = Product.find(id: productid)
    @user = @product.user
    @room = Room.find(id: roomid)
    subject = @delivery.buyer.first_name + " just ordered your " + @product.name
    mail(to: @product.user.email, subject: subject)
  end

  def new_delivery_email_admin_later(orderid, adminid, roomid)
    @delivery = Order.find(id: orderid)
    @admin = User.find(id: adminid)
    @room = Room.find(id: roomid)
    mail(to: @admin.email, subject: "Delivery order incoming!")
  end

  def cancel_delivery_admin_later(userid, adminid, roomid)
    @user = User.find(id: userid)
    @admin = User.find(id: adminid)
    @room = Room.find(id: roomid)
    subject = @user.first_name + " just cancelled the delivery"
    mail(to: @admin.email, subject: subject)
  end
end
