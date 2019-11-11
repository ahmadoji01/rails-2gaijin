class SearchController < ApplicationController
  include Pagy::Backend
  
  def index
    query = ""

    if params.has_key?(:q)
      if params[:q] != ""
        query = params[:q]
      end
    end

    if params.has_key?(:user)
      if params[:user] != ""
        @user = User.find(params[:user])
      else
        params.delete(:user)
      end
    end

    if params.has_key?(:status)
      if params[:status] == "0"
        params.delete(:status)
      end
    end

    @currcategory = []
    @currcategory2 = []
    @currcategoryname = []
    @currcategory2name = []

    if params.has_key?(:categoryname)
      @currcategory.push(Category.find_by(name: params[:categoryname]))
      @currcategory2.push(Category.find_by(name: params[:categoryname]))
      @currcategoryname.push(params[:categoryname])
      @currcategory2name.push(params[:categoryname])
    end

    if params.has_key?(:category)
      if params[:category].has_key?(:name)
        params[:category][:name].each do |category|
          if category != ""
            @currcategory.push(Category.find_by(name: category))
            @currcategoryname.push(category)
          end
        end
      end
    end

    if !params.has_key?(:activecategory)
      if params.has_key?(:relatedcategory)
        params[:relatedcategory].each do |category|
          if category != ""
            @currcategory.push(Category.find_by(name: category))
            @currcategory2.push(Category.find_by(name: category))
            @currcategoryname.push(category)
            @currcategory2name.push(category)
          end
        end
      end
    end

    if params.has_key?(:category2)
      params[:category2].each do |category|
        if category != ""
          @currcategory2.push(Category.find_by(name: category))
          @currcategory2name.push(category)
        end
      end
    end

    @includedcategory = []

    if params.has_key?(:activecategory)
      if params[:activecategory].to_i == 1
        @currcategory.each do |category|
          catproduct = filter_category(category.products.full_text_search(query, allow_empty_search: true), params)
          @includedcategory = @includedcategory + catproduct
        end
        @currcategory2 = @currcategory
      elsif params[:activecategory].to_i == 2
        @currcategory2.each do |category|
          catproduct = filter_category(category.products.full_text_search(query, allow_empty_search: true), params)
          @includedcategory = @includedcategory + catproduct
        end
        @currcategory = @currcategory2
      else
        @currcategory.each do |category|
          catproduct = filter_category(category.products.full_text_search(query, allow_empty_search: true), params)
          @includedcategory = @includedcategory + catproduct
        end
        @currcategory = @currcategory2
      end
    else
      @currcategory.each do |category|
        catproduct = filter_category(category.products.full_text_search(query, allow_empty_search: true), params)
        @includedcategory = @includedcategory + catproduct
      end
      @currcategory = @currcategory2
    end

    if !params.has_key?(:page)
      if params.has_key?(:user)
        ahoy.track "Searched User's Product", user_id: params[:user].to_s, category: @currcategory.map(&:name), sortby: sort_type(params[:sortby])
      else
        ahoy.track "Searched Product", query: params[:q].to_s, category: @currcategory.map(&:name), sortby: sort_type(params[:sortby])
      end
    end
    
    if @currcategory.count == 0 || @currcategory2.count == 0 
      if params.has_key?(:user)
        @products = Product.full_text_search(query, allow_empty_search: true)
      else
        @products = Product.full_text_search(query, allow_empty_search: true)
      end
      filtering_params(params).each do |key, value|
        @products = @products.public_send(key, value) if value.present?
      end
    else
      @products = []
      @includedcategory = @includedcategory.uniq
      @includedcategory.each do |product| 
        @products.push(product)
      end
      if params.has_key?(:sortby)
        @products = product_array_sort_by(@products, params[:sortby])
      end
    end

    itemsperpage = 20
    currpage = params[:page].to_i
    if currpage == 0
      currpage = 1
    end

    @pagy, @products = pagy_array(@products, page: params[:page], items: itemsperpage)
  end

  private

  def sort_type(sortby)
    if sortby.to_i == 1
      sortmode = "Price: High to Low"
    elsif sortby.to_i == 2
      sortmode = "Price: Low to High"
    elsif sortby.to_i == 3
      sortmode = "Newest to Oldest"
    elsif sortby.to_i == 4
      sortmode = "Oldest to Newest"
    else
      sortmode = ""
    end
    return sortmode
  end

  def product_array_sort_by(products, sortby)
    if sortby.to_i == 1
      products = products.sort_by! {|k| k["price"]}.reverse!
    elsif sortby.to_i == 2
      products = products.sort_by! {|k| k["price"]}
    elsif sortby.to_i == 3
      products = products.sort_by! {|k| k["created_at"].to_s}.reverse!
    elsif sortby.to_i == 4
      products = products.sort_by! {|k| k["created_at"].to_s}
    end
    return products
  end

  def filter_categories(categories, params)
    i = 0
    while(i < categories.length)
      filtering_params(params).each do |key, value|
        if key != :sortby
          categories[i] = categories[i].public_send(key, value) if value.present?
        end
      end
      i = i + 1
    end
    return categories
  end

  def filter_category(category, params)
    filtering_params(params).each do |key, value|
      if key != :sortby
        category = category.public_send(key, value) if value.present?
      end
    end
    return category
  end

  def validate_products(products)
    if products.count > 0
      return products.asc(:price).page(params[:page])
    else
      return products
    end
  end

  # A list of the param names that can be used for filtering the Product list
  def filtering_params(params)
    params.slice(:user, :minprice, :maxprice, :status, :sortby, :pricesort, :datesort)
  end

end
