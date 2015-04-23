class PostsController < ApplicationController
  before_action :set_ministry, only: [:index]
  before_action :set_post, only: [:show]
  respond_to :html, :json

  def index
    context = @ministry.posts || Post.w_out_pages
    
    @posts = context.current.relevance_order
      .paginated(params[:page].to_i).per(20)
      .all
    render @posts, layout: !request.xhr?
  end

  def show
    render @post,  layout: !request.xhr?
  end


private
  def set_post
    @post = Post.find(params[:id])
  end
  
  def set_ministry
    if params[:ministry]
      @ministry = Ministry.friendly.find(params[:ministry])
    end
  end
end
