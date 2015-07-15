class Admin::CommArtsRequestsController < Admin::BaseController
  before_action :set_comm_arts_request, only: [:show, :edit, :update, :toggle_archive, :destroy]

  def index
    requests = CommArtsRequest.includes(:post, :ministry, :author)
    @unarchived_requests = requests.where(archived_at: nil)
    @archived_requests = requests.where('archived_at is not null')
  end

  def create
  end

  def update
  end

  def toggle_archive
    if @request.archived_at.present?
      @request.update_attribute(:archived_at, nil)
    else
      @request.touch :archived_at
    end

    render nothing: true
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
