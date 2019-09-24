class HomeController < ApplicationController

	def index
		@delivery = Delivery.new
		@products = Product.all.order(created_at: :desc).page(params[:page])
		@recentproducts = Product.all.order(created_at: :desc).limit(8)

		@whiteapplcat = Category.find_by(name: "White Appliances")
		@furniturecat = Category.find_by(name: "Furnitures")
		@electronicscat = Category.find_by(name: "Electronics")
		@electronics = Product.where(category_ids: [@electronicscat.id]).order(created_at: :desc).page(params[:electspage])
		@whiteappls = Product.where(category_ids: [@whiteapplcat.id]).order(created_at: :desc).page(params[:applspage])
		@furnitures = Product.where(category_ids: [@furniturecat.id]).order(created_at: :desc).page(params[:furnspage])
	end
end
