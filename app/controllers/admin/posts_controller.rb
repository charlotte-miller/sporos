class Admin::PostsController < Admin::BaseController
  include PostsHelper
  
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_type, only: [:show, :edit, :update, :destroy]

  # rescue_from ::LinkThumbnailer::BadUriFormat,      with: :bad_request
  # rescue_from ::ActionController::ParameterMissing, with: :bad_request
  # rescue_from ::NameError,                          with: :bad_request

  respond_to :html

  def index
    my_recently_approved_posts = current_user.posts.where(['published_at > ?', 2.days.ago]).order(published_at: :desc).limit(5)
    i_should_approve           = current_user.approval_requests.action_required.includes(:post).paginated(params[:page]).per(20).map(&:post)
    i_wrote_this               = current_user.posts.paginated(params[:page]).per(20)
    my_pending_posts           = i_wrote_this.pending
    my_rejected_posts          = i_wrote_this.rejected
      
    @grouped_posts = {
      "Recently Published" => my_recently_approved_posts,
      "Approval Required"  => i_should_approve,
      "Rejected Posts"     => my_rejected_posts,
      "Pending Posts"      => my_pending_posts,
    }
    
    
    respond_with(@grouped_posts)
  end

  def show
    # comments
    
    respond_with(@post)
  end

  def new
    @post = Post.new
    @type = params[:post_type]
    @ministries = current_user.ministries
    
    respond_with(@post)
  end

  def edit
  end

  def create
    post_class = post_params[:type].constantize
    @post = post_class.new(post_params.merge(author:current_user) )
    @post.save
    respond_with(@post)
  end

  def update
    @post.update(post_params)
    respond_with(@post)
  end

  def destroy
    @post.destroy
    respond_with(@post)
  end

  # GET /admin/posts/link_preview?url=<URL>
  def link_preview
    @preview = LinkThumbnailer.generate params[:url]#, image_stats:'false'
    render json: @preview
  end
  
  private
    def set_post
      @post ||= current_user.posts.find_by(public_id:params[:id])
      @post ||= current_user.approval_requests.action_required.includes(:post).map(&:post).find {|post| post.public_id == params[:id]}
    end
    
    def set_type
      @type ||= post_type_of( @post )
    end
    
    def post_params
      params.require(:post).permit(:type, :ministry_id, :title, :description, :display_options, :poster, :expired_at)
    end
    
    def posts_links_url
      admin_posts_url
    end
    
    def posts_link_url(post)
      admin_post_url(post)
    end
end
