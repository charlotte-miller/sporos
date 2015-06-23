class Admin::ApprovalRequestsController < Admin::BaseController
  include PostsHelper
  
  before_action :merge_commit_into_params
  before_action :set_approval_request

  def show
    @comments = @approval_request.comment_threads
    @current_users_approval_request =  @approval_request
    @post = @approval_request.post
    
    if stale?(:etag => @approval_request.id, :last_modified => @approval_request.updated_at.utc, :public => true)
      render json: comments_data
    end
  end
  
  def update
    @approval_request.update(approval_request_params)
    
    # comments_data
    @comments = @approval_request.comment_threads
    @current_users_approval_request =  @approval_request
    @post = @approval_request.post
    
    render json: comments_data
  end

  
private
  def set_approval_request
    @approval_request ||= current_user.approval_requests.find(params[:id])
  end
      
  def approval_request_params
    strong_params = params.require(:approval_request).permit(:status, comment_threads_attributes:[:body, :user_id])
    strong_params.merge!(user_id:current_user.id)
    strong_params[:comment_threads_attributes].each {|comment| comment.merge!(user_id:current_user.id) }
    strong_params
  end
  
  def merge_commit_into_params
    return unless params[:commit] =~ /Approve|Reject/
    normalized_status = params[:commit] =~ /Approve/ ? 'accepted' : 'rejected'
    params[:approval_request][:status] = normalized_status
  end
end
