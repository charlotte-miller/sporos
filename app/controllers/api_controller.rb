class ApiController < ActionController::Base
  respond_to :json

  protect_from_forgery with: :null_session

  before_filter :check_auth

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

private

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
