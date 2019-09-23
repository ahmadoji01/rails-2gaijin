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
end
