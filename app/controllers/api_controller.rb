class ApiController < ActionController::Base
  respond_to :json

  protect_from_forgery with: :null_session

  before_filter :check_auth, except: [:groups, :current_lesson]

  # TODO: rescue from can't find user from token and can't find groups from groupid???
  rescue_from JWT::DecodeError, with: :token_error

  def login
    if @token
      render json: { token: @token }, status: 200
    else
      render json: { message: "invalid login/password" }, status: 401
    end
  end

  # GET /api/login_and_visit?href=/users/edit
  def login_and_visit
    sign_in(@user)
    redirect_to params[:href]
  end

  def groups
    @groups = user_from_token.groups
    render "api/groups"
  end

  def current_lesson
    # TODO: Need to handle the case when group has no lessons
    # TODO: Refactor with strong_params
    if params["groupId"].present?
      group = Group.find_by(public_id: params["groupId"])
    else
      # TODO: This default needs to be thought out again
      group = user_from_token.groups.last
    end

    current_meeting = view_context.current_meeting_from(group)
    if current_meeting.present?
      @lesson = current_meeting.lesson
    else
      # group has no current meeting (ex: ended, etc) and so return the last lesson
      @lesson = group.lessons.last
    end

    # TODO: Render only the required info on lesson instead of the whole object
    render json: { lesson: @lesson.as_json }, status: 200

private

  def token_error
    render json: { message: "invalid token" }, status: 401
  end

  def decoded_data
    payload = request.headers['Authorization']
    JWT.decode(payload, AppConfig.firebase.secret_access_key)
  end

  def user_from_token
    user_public_id = decoded_data.first["d"]["uid"]
    User.find_by(public_id: user_public_id)
  end

  def check_auth
     authenticate_or_request_with_http_basic do |username,password|
      @user = User.find_by_email(username)
      if @user && @user.valid_password?(password)
        # TODO: Hard code to the last group since users are assume to be only in one group
        study_group_public_id = @user.groups.last.present? ? @user.groups.last.public_id : "GRP-temporary"
        payload = { uid: @user.public_id, email: @user.email, name: @user.name, group_uid: study_group_public_id }
        generator = Firebase::FirebaseTokenGenerator.new(AppConfig.firebase.secret_access_key)
        @token = generator.create_token(payload)
      end
    end
  end
end
