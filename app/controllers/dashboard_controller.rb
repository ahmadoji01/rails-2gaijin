class DashboardController < ApplicationController
	before_action :authenticate_user!
	before_action :authorized_user

	def index
		if !current_user.role == :admin
			redirect_to root_path
		end
	end

	def delivery_order
		@deliveries = Delivery.where(status_cd: 2).order(created_at: :desc).page(params[:page])
	end

	def user_list
		@users = User.all.order(created_at: :desc).page(params[:page])
	end

	def product_list
		@products = Product.all.order(created_at: :desc).page(params[:page])
	end

	private 

	def authorized_user
		if current_user.role != :admin
			redirect_to root_url
		end
	end
end
