class DeviseOverride::InvitationsController < Devise::InvitationsController
  before_filter :admin_only, only:[:new,:create]
  before_filter :set_ministries, only:[:new,:create]
  before_filter :set_ministry, only: [:create]

  def update
    no_password       = update_resource_params['password'].blank?
    new_profile_image = params[:only_profile_image].present?

    if no_password && new_profile_image
      params[:invitation_token] = update_resource_params['invitation_token']
      resource_from_invitation_token
      resource.restore_attributes [:invitation_token]
      resource.profile_image= params[:only_profile_image]
      if resource.save
        resource.profile_image_processing= false
        file = resource.profile_image
        render json: {
          name: file.basename,
          url:  file.url(:large_thumb),
          thumbnail_url: file.url(:thumb)}
        return
      else
        super
      end
    else
      super
    end
  end

private

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
