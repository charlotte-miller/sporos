class GroupsController < ApplicationController
  before_filter :authenticate_user!,  except:[:index, :show]
  before_filter :safe_select_group,   only: [:show, :edit, :update, :destroy]
  before_filter :safe_select_groups,  only: [:index]

  # GET /groups
  # GET /groups.json
  def index
    if user_signed_in?
      @groups = current_user.groups.includes(:meetings, :lessons_through_meetings)
      @open_groups = @groups.select { |group| group.is_open? }
      @finished_groups = @groups.select { |group| group.is_finished? }
      @user_lesson_states = current_user.user_lesson_states
      .where(['lesson_id IN(?)', @groups.map {|group| group.lessons_through_meetings.map(&:id) }.flatten.uniq])

      template= 'index'
    else
      @groups = Group.includes(:meetings).publicly_searchable.all
      template= 'public_index'
    end

    respond_to do |format|
      format.html { render template: "groups/#{template}" }
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    if user_signed_in?
      @membership.touch #last_attended_at
      template= 'show'
    else
      @group = Group.publicly_searchable.find( params[:id] )
      template= 'public_show'
    end
    respond_to do |format|
      format.html { render template: "groups/#{template}" }
      format.json { render json: @group }
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to user_signed_in? ? groups_url : new_user_session_url
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group ||= group_params[:type].constantize.new(group_params)
    @group.errors.add(:type, 'Not a valid group') unless @group.is_a?(Group)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group.becomes(Group), notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group.becomes(Group) }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update

    respond_to do |format|
      if @group.update_attributes(group_params)
        format.html { redirect_to @group.becomes(Group), notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

private

  def group_params
    raise ArgumentError unless ['Groups::StudyGroup'].include? params[:group][:type]
    @group_params ||= params.require(:group).permit(
      :description, :name, :is_public, :state, :meets_every_days, :poster_img, :poster_img_remote_url, :type,
      :study_id
    )
  end

  # scopes SELECT to current user
  def safe_select_groups
    return unless user_signed_in?
    @groups = current_user.groups
  end

  # scopes SELECT to current user
  def safe_select_group
    return unless user_signed_in? && params[:id]
    @membership = current_user.membership_in(params[:id])
    @group      = @membership.group
  end

end
