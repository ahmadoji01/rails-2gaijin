class CategoryController < ApplicationController
  before_action :authorized_user

  def add
  	@category = Category.new
  end

  private
  	
  	def authorized_user
  		if user_signed_in?
        if current_user.role != :admin
          raise ActionController::RoutingError.new('Not Found')
        end
      else
        raise ActionController::RoutingError.new('Not Found')
      end
	  end
end
