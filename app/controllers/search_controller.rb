class SearchController < ApplicationController
  def index
  	Product.reindex

  	if params.has_key?(:minprice) && (!params.has_key?(:maxprice) || params[:maxprice].empty?) 
  		@products = Product.search params[:q], where: { price: { gte: params[:minprice] } }
  	elsif (!params.has_key?(:minprice) || params[:minprice].empty?) && params.has_key?(:maxprice)
  		@products = Product.search params[:q], where: { price: { lte: params[:maxprice] } }
  	elsif params.has_key?(:minprice) && params.has_key?(:maxprice)
  		@products = Product.search params[:q], where: { price: { gte: params[:minprice], lte: params[:maxprice] } }
  	elsif params.has_key?(:category)
      		@category = Category.find_by(name: params[:category])
      		@products = Product.where(category_ids: [@category.id]).order(created_at: :desc).page(params[:page])
    	else
  		@products = Product.search params[:q]
  	end
  end
end
