class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :domains_for_js
  
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
