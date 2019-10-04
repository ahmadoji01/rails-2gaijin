class SearchController < ApplicationController
  def index
    query = ""

    if params.has_key?(:q)
      query = params[:q]
    end

    if params.has_key?(:category)
      query = query + " " + params[:category]
    end
  	
  	if params.has_key?(:minprice) && (!params.has_key?(:maxprice) || params[:maxprice].empty?) 
  		@products = Product.where(:price.gte => params[:minprice]).full_text_search(query)
      @products = validate_products(@products)
  	elsif (!params.has_key?(:minprice) || params[:minprice].empty?) && params.has_key?(:maxprice)
  		@products = Product.where(:price.lte => params[:maxprice]).full_text_search(query)
      @products = validate_products(@products)
  	elsif params.has_key?(:minprice) && params.has_key?(:maxprice)
  		@products = Product.where(:price.lte => params[:maxprice], :price.gte => params[:minprice]).full_text_search(query)
      @products = validate_products(@products)
    else
  		@products = Product.full_text_search(query)
      @products = validate_products(@products)
  	end
  end

  private

  def validate_products(products)
    if products.count > 0
      return products.asc(:price).page(params[:page])
    else
      return products
    end
  end

end
