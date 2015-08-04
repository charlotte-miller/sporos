class Admin::MinistriesController < Admin::BaseController
  before_action :admin_only,    only:[:new, :create, :destroy]
  before_action :set_ministry,  only: [:edit, :update, :destroy] #:show

  respond_to :html

  def index
    case @ministries.length
    when 1
      redirect_to admin_ministry_url(@ministries.first)
    when 0
      redirect_to edit_user_registration_url
    else
      respond_with(@ministries)
    end
  end

  # def show
  #   grouped_involvements = @ministry.involvements.group_by(&:level)
  #   @grouped_users = grouped_involvements.each_pair do |level, involvements|
  #     grouped_involvements[level] = User.find(involvements.map(&:user_id))
  #   end
  #
  #   respond_with(@ministry)
  # end

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
