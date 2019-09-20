class DashboardController < ApplicationController
	before_action :authenticate_user!

	def index
		if !current_user.role == :admin
			redirect_to root_path
		end
	end

	def delivery_order
		@deliveries = Delivery.all.order(created_at: :desc).page(params[:page])
	end
end
