module ApplicationHelper
	def user_rooms
		Room.where(:user_ids => current_user.id).order_by(last_active: :desc)
	end

	def user_notifications
		Notification.where(:user_id => current_user.id).order_by(created_at: :desc)
	end

	def user_unread_notifs
		Notification.where(:status_cd => 0).and(:user_id => current_user.id).length
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
end
