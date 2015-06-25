class Admin::BaseController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!, :unless => :devise_controller?
  before_filter :set_ministries
  
  layout 'layouts/admin'
  
protected
  def safe_ministry_id
    ministry_ids = current_user.ministries.pluck('id')
    if ministry_ids.length > 1
      if ministry_ids.include? post_params[:ministry_id].to_i
        post_params[:ministry_id] 
      else
        nil
      end
    else
      ministry_ids.first
    end
  end

  def set_ministries
    @ministries ||= if current_user.admin?
      Ministry.all
    else
      current_user.ministries
    end
  end
end
