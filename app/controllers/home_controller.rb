class HomeController < ApplicationController

	def index
		@products = Product.all.order(created_at: :desc).page(params[:page])

		@whiteapplcat = Category.find_by(name: "White Appliances")
		@furniturecat = Category.find_by(name: "Furnitures")
		@whiteappls = Product.where(category_ids: [@whiteapplcat.id]).order(created_at: :desc).page(params[:applspage])
		@furnitures = Product.where(category_ids: [@furniturecat.id]).order(created_at: :desc).page(params[:furnspage])
	end
end
