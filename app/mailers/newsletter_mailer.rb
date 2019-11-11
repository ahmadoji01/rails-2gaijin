class NewsletterMailer < ApplicationMailer
  
  def website_launch_email(user)
  	@user = user
  	mail(to: @user.email, subject: "2Gaijin.com: We are Migrating to a New Website!")
  end

  def new_product_message(user, sender, product, room)
  	@user = user
  	@sender = sender
  	@product = product
  	@room = room
  	subject = @sender.first_name + " just sent a message for your " + @product.name
  	mail(to: @user.email, subject: subject)
  end

  def new_message(user, sender, room, message)
  	@user = user
  	@sender = sender
  	@room = room
    @message = message
  	subject = @sender.first_name + " just sent you a message"
  	mail(to: @user.email, subject: subject)
  end

  def new_message_later(userid, senderid, roomid, message)
    @user = User.find_by(id: userid)
    @sender = User.find_by(id: senderid)
    @room = Room.find_by(id: roomid)
    @message = message
    subject = @sender.first_name + " just sent you a message"
    mail(to: @user.email, subject: subject)
  end

  def new_product_comment(user, commenter, product)
  	@user = user
  	@commenter = commenter
  	@product = product
  	subject = @commenter.first_name + " just left a comment on " + @product.name
  	mail(to: @user.email, subject: subject)
  end

  def new_product_comment_later(userid, commenterid, productid)
    @user = User.find_by(id: userid)
    @commenter = User.find_by(id: commenterid)
    @product = Product.find_by(id: productid)
    subject = @commenter.first_name + " just left a comment on " + @product.name
    mail(to: @user.email, subject: subject)
  end
end
