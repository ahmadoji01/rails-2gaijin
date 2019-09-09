# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout "application"
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

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
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :attribute, :update_attrs])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
