class DeviseOverride::RegistrationsController < Devise::RegistrationsController
  
  def update
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    
    if params[:only_profile_image]
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
    end
    
    super
  end
  
  protected

  def update_resource(resource, params)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      super
    end
    
  end
end