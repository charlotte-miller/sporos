class Admin::ApprovalRequestsController < Admin::BaseController
  include PostsHelper

  before_action :merge_commit_into_params, except:[:editable_posts]
  before_action :set_approval_request,     except:[:editable_posts]

  def show
    set_approval_request_data

    if stale?(:etag => @approval_request, :last_modified => @post.updated_at.utc, :public => true)
      render json: comments_data
    end
  end

  def update
    if @approval_request.update(approval_request_params)
      comment_body = approval_request_params[:comment_threads_attributes].first["body"]
      ApprovalRequestCommentMailer.notify_all(@approval_request.to_findable_hash, comment_body).deliver_later if comment_body.present?
    end

    set_approval_request_data

    render json: comments_data
  end

  def update_status_from_link
    raise ArgumentError unless params[:commit].present?
    @approval_request.update(approval_request_params)

    flash[:success] = "Post #{@approval_request.status.titleize}"
    redirect_to admin_post_url(@approval_request.post)
  end

  def editable_posts
    # - if current_user && current_user.admin? || current_user == post.author
    my_approval_requests = current_user.approval_requests.joins(:post).pluck('posts.public_id')
    render json: { public_ids: my_approval_requests }
  end

private
  def set_approval_request_data
    @comments = @approval_request.post.comment_threads
    @current_users_approval_request =  @approval_request
    @approval_statuses = @current_users_approval_request.current_concensus(:mark_author)
    @post = @approval_request.post
  end

  def set_approval_request
    @approval_request ||= current_user.approval_requests.find(params[:id])
  end

  def approval_request_params
    strong_params = params.require(:approval_request).permit(:status, comment_threads_attributes:[:body, :user_id])
    strong_params.merge!(user_id:current_user.id)
    strong_params[:comment_threads_attributes] ||= []
    strong_params[:comment_threads_attributes].each {|comment| comment.merge!(user_id:current_user.id) }
    strong_params
  end

  def merge_commit_into_params
    return unless params[:commit] =~ /Approve|Reject/
    normalized_status = params[:commit] =~ /Approve/ ? 'accepted' : 'rejected'
    params[:approval_request] ||= {}
    params[:approval_request][:status] = normalized_status
  end
end
