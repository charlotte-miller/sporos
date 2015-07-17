class Admin::CommArtsRequestsController < Admin::BaseController
  before_action :set_comm_arts_request, only: [:show, :edit, :update, :toggle_archive, :destroy]

  def index
    requests = CommArtsRequest.includes(:post, :ministry, :author)
    @ministries = Ministry.all
    @new_request = CommArtsRequest.new
    @unarchived_requests = requests.where(archived_at: nil)
    @archived_requests = requests.where('archived_at is not null').order(archived_at: :desc)
  end

  def create
    @new_request = CommArtsRequest.new(request_params)
    if @new_request.save
      flash[:notice] = "Comm Arts Request created!"
      redirect_to admin_comm_arts_requests_path
    end
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

  def request_params
    @request_params ||= params.require(:comm_arts_request).permit(
      :title,
      :ministry_id,
      :design_purpose,
      :design_tone,
      :design_cta,
      :postcard_quantity,
      :poster_quantity,
      :booklet_quantity,
      :badges_quantity,
      :due_date)
    @request_params[:author_id] = current_user.id
    @request_params
  end

  def set_comm_arts_request
    @request = CommArtsRequest.find(params[:id])
  end
end
