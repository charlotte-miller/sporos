class CommunitiesController < ApplicationController
  # should always render index

  # before_filter :set_posts

  def index
    expires_in 5.seconds, public:true
    fresh_when(etag:@posts, last_modified:last_updated_at, public:true)
    set_posts
  end

  def show
    expires_in 5.seconds, public:true
    fresh_when(etag:@posts, last_modified:last_updated_at, public:true)
    set_posts
    render :index
  end

private
  def last_updated_at
    Post.current.order('updated_at DESC').first.updated_at
  end

  def set_posts
    @posts ||= Post.current
      .featured_order
      .relevance_order
      .paginated(params[:page])
      .per(20)
      .includes(:uploaded_files, :ministry)
      .all
  end

  def get_ministry
    Ministry.find(community_params.id)
  end

  def community_params
    @community_params ||= DeepStruct.new(params.permit(:id))
  end
end
