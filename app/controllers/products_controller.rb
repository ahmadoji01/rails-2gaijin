class ProductsController < ApplicationController
  before_action :redirect_if_no_session, only: [:edit, :update, :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @relatedproducts = Product.where(category_ids: @product.category_ids).order(created_at: :desc).limit(8)
    @userproducts = Product.where(user_id: @product.user.id).order(created_at: :desc).limit(8)
    @comments = Comment.where(product_id: @product.id)
    @comment = Comment.new
  end

  # GET /products/new
  def new
    @product = Product.new
    @categories = Category.all
  end

  # GET /products/1/edit
  def edit
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

    categories = params[:categories]

    categories.each do |category|
      cat = Category.find(category)
      @product.categories << cat
    end

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update

    @product.categories = []
    categories = params[:product][:categories]
    @product.updated_at = DateTime.now

    categories.each do |category|
      if !category.blank?
        cat = Category.find(category)
        @product.categories << cat
      end
    end

    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
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
      params.require(:product).permit(:name, :description, :price, :created_at, :updated_at, :latitude, :longitude, :image, :categories)
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
end
