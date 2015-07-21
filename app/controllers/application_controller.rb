class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :domains_for_js
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || admin_posts_url
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

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:invite).concat [:involvement_ministry_id, :involvement_level, :first_name, :last_name]
    devise_parameter_sanitizer.for(:accept_invitation).concat [:profile_image]
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name) }
    # devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password, :first_name, :last_name, :profile_image) }
  end
end
