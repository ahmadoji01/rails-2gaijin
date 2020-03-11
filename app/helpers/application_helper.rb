module ApplicationHelper
	include Pagy::Frontend
	def user_rooms
		if user_signed_in?
			Room.where(:user_ids => current_user.id).order_by(last_active: :desc)
		end
	end

	def user_notifications
		if user_signed_in?
			Notification.where(:user_id => current_user.id).order_by(created_at: :desc)
		end
	end

	def user_unread_notifs
		if user_signed_in?
			Notification.where(:status_cd => 0).and(:user_id => current_user.id).length
		end
	end

	def user_unread_rooms
		if user_signed_in?
			unreadrooms = Room.where(:user_ids => current_user.id)
    		counter = 0

		    unreadrooms.each do |room|
		    	last_message = room.room_messages.order(created_at: :desc).first
		    	if last_message.present?
					if !last_message.reader_ids.include?(current_user.id)
			        	counter = counter + 1
			    	end
			  	end
		    end
		    return counter
		end
	end

	def room_is_read(room)
		if user_signed_in?
			if !room.room_messages.present?
				return true
			else
				last_message = room.room_messages.order(created_at: :desc).first
				if last_message.present?
					if last_message.reader_ids.include?(current_user.id)
						return true
					else
						return false
					end
				end
			end
		end
	end

	def new_delivery
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
				delivery.buyer = current_user
				delivery.status = :active
				
				if delivery.save
					return delivery
				end
			end
		end
	end

	def user_avatar
		if user_signed_in?
			if current_user.avatar?
				return current_user.avatar.url
			else
				return "avatar/avatar-1.png"
			end
		else
			return "avatar/avatar-1.png"
		end
	end

	def user_avatar_thumb
		if user_signed_in?
			if current_user.avatar?
				if current_user.avatar.thumb.present?
					return current_user.avatar.thumb.url
				else
					return "avatar/avatar-1.png"
				end
			else
				return "avatar/avatar-1.png"
			end
		else
			return "avatar/avatar-1.png"
		end
	end

	def mobile_device?
	    if session[:mobile_param]
	      session[:mobile_param] == "1"
	    else
	      request.user_agent =~ /Mobile|webOS/
	    end
	end

	def another_user_avatar(another_user)
		if another_user.avatar?
			return another_user.avatar.url
		else
			return "avatar/avatar-1.png"
		end
	end

	def another_user_avatar_thumb(another_user)
		if another_user.avatar?
			if another_user.avatar.thumb.present?
				return another_user.avatar.thumb.url
			else
				return "avatar/avatar-1.png"
			end
		else
			return "avatar/avatar-1.png"
		end
	end
end
