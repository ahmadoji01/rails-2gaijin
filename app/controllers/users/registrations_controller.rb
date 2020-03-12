# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include Pagy::Backend  
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  invisible_captcha only: [:create]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  def edit
    @products = Product.where(user_id: current_user.id).order(created_at: :desc).page(params[:page])
    @addresses = Address.where(user_id: current_user.id)
    @newaddress = Address.new
  end

  def edit_password
  end

  def edit_delivery
    @deliveries = Order.where(email: current_user.email)
    render :layout => 'application'
  end

  def edit_product
    @products = current_user.products.order(created_at: :desc)
    @pageinfo = page_info(10, @products.count, params[:page].to_i)

    @pagy, @products = pagy_array(@products, page: params[:page], items: 10)
    render :layout => 'application'
  end

  def edit_product_form
    @product = User.find(params[:id])
    respond_to do |format|
      format.js { render partial: "product_form", locals: {product: @product}}
    end
  end

  def edit_address
    @addresses = Address.where(user_id: current_user.id)
    @newaddress = Address.new
    render :layout => 'application'
  end

  def edit_job_application
    @jobapps = JobsApplication.where(user_id: current_user.id)
    render :layout => 'application'
  end

  def edit_item_order
    @orderproducts = OrderProduct.where(seller_id: current_user.id) 
    render :layout => 'application'
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :attribute])
  end

  def update_resource(resource, params)
    if params[:current_password].blank?
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    update_attrs = [:password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :attribute, :avatar, :update_attrs])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def page_info(itemsperpage, totalitems, currpage)
    currpage = params[:page].to_i
    if currpage == 0
      currpage = 1
    end

    startrange = ((currpage - 1) * itemsperpage) + 1
    endrange = currpage * itemsperpage
    if endrange > totalitems
      endrange = totalitems
    end

    return "Displaying <b>" + totalitems.to_s + "</b> items (<b>" + startrange.to_s + "</b>-<b>" + endrange.to_s + "</b>)"
  end
end
