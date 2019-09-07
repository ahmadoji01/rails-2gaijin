class SearchController < ApplicationController
  def index
  	Product.reindex


  	if params.has_key?(:minprice) && (!params.has_key?(:maxprice) || params[:maxprice].empty?) 
  		@products = Product.search params[:q], where: { price: { gt: params[:minprice] } }
  	elsif (!params.has_key?(:minprice) || params[:minprice].empty?) && params.has_key?(:maxprice)
  		@products = Product.search params[:q], where: { price: { lt: params[:maxprice] } }
  	elsif params.has_key?(:minprice) && params.has_key?(:maxprice)
  		@products = Product.search params[:q], where: { price: { gt: params[:minprice], lt: params[:maxprice] } }
  	else
  		@products = Product.search params[:q]
  	end
  end
end
