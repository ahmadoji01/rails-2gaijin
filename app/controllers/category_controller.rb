class CategoryController < ApplicationController
  def add
  	@category = Category.new
  end
end
