class DeliveryMailer < ApplicationMailer
  def new_delivery_email
  	@delivery = Delivery.find(id: params[:delivery_id])
  	mail(to: @delivery.user.email, subject: "Here is the summary of your delivery order!")
  end
end
