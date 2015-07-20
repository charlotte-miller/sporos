class CommunitiesController < ApplicationController
  # should always render index

  before_filter :set_posts

  def index

  end

  def show
    render :index
  end

private

  def set_posts
    @posts ||= Post.current
      .relevance_order
      .paginated(params[:page])
      .per(20)
      .includes(:uploaded_files, :ministry)
      .all

    @featured_posts = @posts.where('featured_at is not null')
  end

  def get_ministry
    Ministry.find(community_params.id)
  end

  def community_params
    @community_params ||= DeepStruct.new(params.permit(:id))
  end
end
