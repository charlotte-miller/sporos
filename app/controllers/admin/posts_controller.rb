class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @posts = current_user.posts
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
    @type = @post.class_name.downcase
  end

  def create
    @post = Post.new(post_params.merge(author:current_user))
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

  private
    def set_post
      @post = current_user.posts.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:type, :ministry_id, :title, :description, :display_options, :poster, :expired_at)
    end
end
