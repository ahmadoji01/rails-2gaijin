class ApplicationController < ActionController::Base

  layout :layout_by_resource
  before_action :set_locale
  before_action { @pagy_locale = I18n.locale.to_s }

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  private
  def layout_by_resource
    if devise_controller?
      if(controller_name == 'registrations' && action_name == 'edit')
      	"application"
      else
      	"authentication"
      end
    else
      "application"
    end
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  def update_user_locale(locale)
    current_user.update_attribute :locale, locale
  end

  def set_locale
    if user_signed_in?
      if params.has_key?(:locale)
        update_user_locale(params[:locale])
      end
      if current_user.locale.present?
        I18n.locale = current_user.locale
      else
        I18n.locale = params[:locale] || I18n.default_locale
      end
    else
      if params.has_key?(:locale)
        session[:locale] = params[:locale]
      end
      I18n.locale = session[:locale] || I18n.default_locale
    end
  end
end
