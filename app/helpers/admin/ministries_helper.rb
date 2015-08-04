module Admin::MinistriesHelper

  def edit_current_user_path
    ministries = current_user.ministries
    case current_user.ministries.length
    when 1
      edit_admin_ministry_path(ministries.first)
    when 0
      edit_user_registration_path
    else
      admin_ministries_path
    end
  end

end
