class SearchController < ApplicationController
  def index
  	Product.reindex
  	@products = Product.search(params[:q])
  end
end
