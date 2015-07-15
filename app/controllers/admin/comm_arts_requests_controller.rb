class Admin::CommArtsRequestsController < Admin::BaseController
  before_action :set_comm_arts_request, only: [:show, :edit, :update, :archive, :destroy]

  def index
    @requests = CommArtsRequest.includes(:post, :ministry, :author)
  end

  def create
  end

  def update
  end

  def archive
    @request.archived_at = DateTime.now
    if @request.save
      render nothing: true
    end
  end

  def destroy
    if @request.destroy
      flash[:notice] = "Request successfully deleted"
      redirect_to admin_comm_arts_requests_path
    end
  end

  private

  def set_comm_arts_request
    @request = CommArtsRequest.find(params[:id])
  end
end
