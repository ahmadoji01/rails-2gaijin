class ApplicationController < ActionController::Base

  layout :layout_by_resource

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

end
