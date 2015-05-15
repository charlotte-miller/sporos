class PostsController < ApplicationController
  before_action :set_ministry, only: [:index]
  before_action :set_post, only: [:show]
  respond_to :html, :json

  def index
    context = @ministry.try(:posts) || Post.w_out_pages
    
    @posts = context.current.relevance_order
      .paginated(params[:page]).per(20)
      .all
    
    render template:'posts/show', layout: !request.xhr?
  end

  def show
    respond_to do |format|
      format.html { render template:'posts/show',  layout: !request.xhr?}
      format.json { render json: @post }
    end
    
  end


private
  def set_post
    @post ||= Post.includes(:uploaded_files).find_by(public_id:params[:id])
  end
  
  def set_ministry
    if params[:ministry]
      @ministry = Ministry.friendly.find(params[:ministry])
    end
  end
end
