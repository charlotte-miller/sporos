class Admin::PostsController < Admin::BaseController
  include PostsHelper
  
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_type, only: [:show, :edit, :update, :destroy]

  # rescue_from ::LinkThumbnailer::BadUriFormat,      with: :bad_request
  # rescue_from ::ActionController::ParameterMissing, with: :bad_request
  # rescue_from ::NameError,                          with: :bad_request

  respond_to :html

  def index
    @posts =  current_user.approval_requests.paginated(params[:page].to_i).per(20).map(&:post) | current_user.posts.paginated(params[:page].to_i).per(20)
    respond_with(@posts)
  end

  def show
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
