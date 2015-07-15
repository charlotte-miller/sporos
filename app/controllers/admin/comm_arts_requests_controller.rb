class Admin::CommArtsRequestsController < Admin::BaseController
  def index
    @requests = CommArtsRequest.includes(:post, :ministry, :author)
  end

  def create
  end

  def update
  end

  def destroy
    @request = CommArtsRequest.find(params[:id])
    if @request.destroy
      flash[:notice] = "Request successfully deleted"
      redirect_to admin_comm_arts_requests_path
    end
  end
end
