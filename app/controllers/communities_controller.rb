class CommunitiesController < ApplicationController
  # should always render index
  
  def index
    
  end
  
  def show    
    render :index
  end
  
private
  
  def get_ministry
    Ministry.find(community_params.id)
  end
  
  def community_params
    @community_params ||= DeepStruct.new(params.permit(:id))
  end
end
