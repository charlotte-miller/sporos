class Admin::CommArtsRequestsController < Admin::BaseController
  def index
    @requests = CommArtsRequest.all
  end

  def create
  end

  def update
  end

  def destroy
  end
end
