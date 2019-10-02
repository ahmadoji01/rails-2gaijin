module ApplicationHelper
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

	def new_delivery
		if user_signed_in?
			delivery = Delivery.where(:user_id => current_user.id, :status_cd => 1)
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
				delivery = Delivery.new

				delivery.address = address
				delivery.user = current_user
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
			if current_user.avatar.thumb.present?
				return current_user.avatar.thumb.url
			else
				return "avatar/avatar-1.png"
			end
		else
			return "avatar/avatar-1.png"
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
		if another_user.avatar.thumb.present?
			return another_user.avatar.thumb.url
		else
			return "avatar/avatar-1.png"
		end
	end
end
