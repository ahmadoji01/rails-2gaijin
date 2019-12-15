class HomeController < ApplicationController

	def index
		@delivery = Delivery.new
		@recentproducts = Product.status(1).order(created_at: :desc).limit(18)
		@freeproducts = Product.status(1).where(price: 0).order(created_at: :desc).limit(18)

		@electronics = Product.limit(8).order(created_at: :desc).status(1).full_text_search("Electronics")
		@kitchens = Product.limit(8).order(created_at: :desc).status(1).full_text_search("Kitchens")
		@furnitures = Product.limit(8).order(created_at: :desc).status(1).full_text_search("Furnitures")
	end
end
