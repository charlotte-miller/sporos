class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :domains_for_js
  
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || admin_ministries_url
  end
  
protected

  def domains_for_js
    gon.domains = AppConfig.domains
  end
  
  def format_json?
    request.format.json?
  end

  # # Devise: Overwriting the sign_out redirect path method
  # def after_sign_out_path_for(resource_or_scope)
  #   root_path
  # end
end
