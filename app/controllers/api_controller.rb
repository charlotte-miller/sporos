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

private

  def check_auth
     authenticate_or_request_with_http_basic do |username,password|
      resource = User.find_by_email(username)
      if resource && resource.valid_password?(password)
        payload = { uid: resource.public_id, email: resource.email, name: resource.name }
        generator = Firebase::FirebaseTokenGenerator.new(AppConfig.firebase.secret_access_key)
        @token = generator.create_token(payload)
      end
    end
  end
end
