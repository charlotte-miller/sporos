class Admin::ApprovalRequestsController < Admin::BaseController
  
  before_action :set_approval_request

  respond_to :html, :json

  def update
    @approval_request.update(approval_request_params)
    respond_with(@approval_request)
  end


  
private
  def set_approval_request
    @approval_request ||= current_user.approval_requests.find(params[:id])
  end
      
  def approval_request_params
    params.require(:approval_request).permit(:type, :ministry_id, :title, :description, :display_options, :approval_requester, :expired_at)
  end
  
  # def approval_requests_links_url
  #   admin_approval_requests_url
  # end
  #
  # def approval_requests_link_url(approval_request)
  #   admin_approval_request_url(approval_request)
  # end
end
