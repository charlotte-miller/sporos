module HttpAuthentication

  CREDENTIALS = [AppConfig.dev_user, AppConfig.dev_pass]

  ## Usage:
  ## require 'mixins/http_authentication'
  ## before_filter :authenticate_developer
  def authenticate_developer
    authenticate_or_request_with_http_basic('Restricted Area') do |username, password|
      [username, password] == CREDENTIALS
    end
  end


  ## Usage:
  ## require 'mixins/http_authentication'
  ## mount RESQUE_DASHBOARD
  require 'resque/server'
  RESQUE_DASHBOARD = Rack::Auth::Basic.new(Resque::Server) do |username, password|
    [username, password] == CREDENTIALS
  end
  
  # OR w/ Devise https://github.com/resque/resque/wiki/FAQ#how-do-you-protect-resque-web-with-devise
end

include HttpAuthentication