class DeviseOverride::InvitationsController < Devise::InvitationsController
  before_filter :admin_only, only:[:new,:create]
  before_filter :set_ministries, only:[:new,:create]
  before_filter :set_ministry, only: [:create]
  
  def set_ministries
    authenticate_user! unless current_user
    @ministries = current_user.ministries
  end
  
  def set_ministry
    unless @ministries.map(&:id).include? params[:user][:involvement_ministry_id].to_i
      @ministry = params[:user][:involvement_ministry_id] = @ministries.first
    end
  end
  
  def admin_only
    authenticate_user! unless current_user
    unless current_user.admin?
      (redirect_to root_path) && return
    end
  end
end