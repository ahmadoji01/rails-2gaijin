class ProductsController < ApplicationController
  include Pagy::Backend
  before_action :redirect_if_no_session, only: [:edit, :update, :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]
  before_action :authorized_user, except: [:show, :new, :mark_as_sold, :create, :update, :destroy, :unfollow]
  invisible_captcha only: [:create]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
    ahoy.track "Viewed Product", id: @product.id.to_s
    if params.has_key?(:notification_id)
      notif = Notification.find(id: params[:notification_id])
      if notif.unread?
        notif.update_attribute :status, :read
      end
    end

    @includedcategory = []
    @relatedproducts = []
    @relatedcategory = [] 
    @product.categories.each do |category|
      @relatedcategory.push(category.name)
      category.products.each do |catproduct| 
        if @relatedproducts.count < 8 && catproduct.status != :sold
          @relatedproducts.push(catproduct)
        end
      end
    end

    @userproducts = Product.where(user_id: @product.user.id).status(1).order(created_at: :desc).limit(8)
    @comments = Comment.where(product_id: @product.id).order(created_at: :desc)
    @comment = Comment.new
  end

  # GET /products/new
  def new
    @product = Product.new
    @product_image = @product.product_images.build
    @categories = Category.all
  end

  # GET /products/1/edit
  def edit
  end

  def unfollow
    @product = Product.find(params[:id])
    
    if @product.followers.delete(current_user)
      sweetalert_success('You have successfully unfollowed this product', 'Successfully Unfollowed', button: 'Awesome!')
      redirect_to @product
    end
  end

  def mark_as_sold
    @product = Product.find(params[:id])
    
    @status = :sold
    if @product.status == :sold
      @status = :active
    end

    @product.status = @status
    @product.updated_at = DateTime.now

    respond_to do |format|
      if @product.update
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.user = current_user
    @product.status = :active
    @product.created_at = DateTime.now
    @product.updated_at = DateTime.now
    
    current_user.products << @product
    current_user.update

    if params.has_key?(:categories)
      categories = params[:categories]
      categories.each do |category|
        cat = Category.find(category)
        @product.categories << cat
        cat.products << @product
        cat.update
      end
    end

    #respond_to do |format|
    if @product.save
      if params[:product_images].present?
        params[:product_images]['image'].each do |i|
          @product_image = @product.product_images.create!(:image => i, :product_id => @product.id)
        end
        #render "crop"
        redirect_to @product, notice: 'Product was successfully created.'
      else
        redirect_to @product, notice: 'Product was successfully created.'
      end
      #format.html { redirect_to @product, notice: 'Product was successfully created.' }
      #format.json { render :show, status: :created, location: @product }
    else
      render :new
      #format.json { render json: @product.errors, status: :unprocessable_entity }
    end
    #end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    @product = Product.find(params[:id])
    @product.updated_at = DateTime.now

    if params[:product].has_key?(:categories)
      categories = params[:product][:categories]
      categories.each do |category|
        if !category.blank?
          cat = Category.find(category)
          @product.categories << cat
        end
      end
    end

    #respond_to do |format|
      if @product.update(product_params)
        redirect_to @product, notice: 'Product was successfully updated.'
        #format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        #format.json { render :show, status: :ok, location: @product }
      else
        render :edit
        #format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    #end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to user_product_path, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :created_at, :updated_at, :latitude, :longitude, :categories, 
                                      product_images_attributes: [:id, :product_id, :image, :crop_x, :crop_y, :crop_w, :crop_h])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content)
    end

    def redirect_if_no_session
      if !user_signed_in?
        redirect_to root_url
      end
    end

    def authorized_user
      if user_signed_in?
        if current_user.role != :admin
          raise ActionController::RoutingError.new('Not Found')
        end
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    end
end
