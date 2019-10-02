class CategoryController < ApplicationController
  before_action :authorized_user

  def add
  	@category = Category.new
  end

  private
  	
  	def authorized_user
  		if current_user.role != :admin
    		redirect_to root_url
  		end
	end
end
