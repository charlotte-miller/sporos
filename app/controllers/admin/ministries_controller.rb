class Admin::MinistriesController < Admin::BaseController
  before_action :admin_only,    only:[:new, :create, :destroy]
  before_action :set_ministry,  only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @ministries = if current_user.admin?
      Ministry
    else
      current_user.ministries
    end.paginated(params[:page].to_i).per(20).all
    
    respond_with(@ministries)
  end

  def show
    #Ministry Dashboard
    @posts = @ministry.posts
      .paginated(params[:page].to_i).per(20)
      .group('published_at IS NULL AS Published')
      .all
    
    respond_with(@ministry)
  end

  def edit
  end

  def update
    @ministry.update(ministry_params)
    respond_with(@ministry, location: admin_ministry_url(@ministry))
  end

  #admin_only
  def new
    @ministry = Ministry.new
    respond_with(@ministry)
  end

  #admin_only
  def create
    @ministry = Ministry.new(ministry_params)
    @ministry.save
    respond_with(@ministry)
  end

  #admin_only
  def destroy
    @ministry.destroy
    respond_with(@ministry)
  end

  private
    def set_ministry
      @ministry = Ministry.friendly.find(params[:id])
    end

    def ministry_params
      params.require(:ministry).permit(:name, :description)
    end
    
    def admin_only
      (redirect_to :index and return) unless current_user.admin?
    end
    
    def ministry_url(*args)
      admin_ministry_url(*args)
    end
    
    def ministries_url(*args)
      admin_ministries_url(*args)
    end
end
