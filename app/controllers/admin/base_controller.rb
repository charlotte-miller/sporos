class Admin::BaseController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!, :unless => :devise_controller?
  before_filter :set_ministries
  
  layout 'layouts/admin'
  
protected

  def set_ministries
    @ministries ||= if current_user.admin?
      Ministry.all
    else
      current_user.ministries
    end
  end
end
