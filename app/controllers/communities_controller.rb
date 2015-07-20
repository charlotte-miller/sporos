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
