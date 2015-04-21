class PostsController < ApplicationController
  before_action :set_post, only: [:show]
  respond_to :html, :json

  def index
    @posts = Post.all
    render @posts, layout: !request.xhr?
  end

  def show
    render @post,  layout: !request.xhr?
  end


  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:type, :title, :description, :display_options, :poster, :expired_at)
    end
end
