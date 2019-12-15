class DeliveryMailer < ApplicationMailer
  def new_delivery_email
  	@delivery = Delivery.find(id: params[:delivery_id])
  	mail(to: @delivery.user.email, subject: "Here is the summary of your delivery order!")
  end

  def new_delivery_email_admin
  	@delivery = Delivery.find(id: params[:delivery_id])
  	@admins = User.admins
  	if @admins.count > 0
  		@admins.each do |admin|
  			mail(to: admin.email, subject: "Delivery order incoming!")
  		end
  	end
  end

  def new_delivery_email_later(deliveryid)
    @delivery = Delivery.find(id: deliveryid)
    mail(to: @delivery.user.email, subject: "Here is the summary of your delivery order!")
  end

  def new_item_from_delivery_order_email_later(deliveryid, productid, roomid)
    @delivery = Delivery.find(id: deliveryid)
    @product = Product.find(id: productid)
    @user = @product.user
    @room = Room.find(id: roomid)
    subject = @delivery.user.first_name + " just ordered your " + @product.name
    mail(to: @product.user.email, subject: subject)
  end

  def new_delivery_email_admin_later(deliveryid, adminid, roomid)
    @delivery = Delivery.find(id: deliveryid)
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
