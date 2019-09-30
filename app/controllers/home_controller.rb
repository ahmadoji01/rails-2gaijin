class HomeController < ApplicationController

	def index
		
		@delivery = Delivery.new
		@products = Product.all.order(created_at: :desc).page(params[:page])
		@recentproducts = Product.all.order(created_at: :desc).limit(8)

		@whiteapplcat = Category.find_by(name: "White Appliances")
		@furniturecat = Category.find_by(name: "Furnitures")
		@electronicscat = Category.find_by(name: "Electronics")
		@electronics = Product.where(category_ids: [@electronicscat.id]).limit(7).order(created_at: :desc)
		@whiteappls = Product.where(category_ids: [@whiteapplcat.id]).limit(7).order(created_at: :desc)
		@furnitures = Product.where(category_ids: [@furniturecat.id]).limit(7).order(created_at: :desc)
	end
end
