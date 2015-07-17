require 'cgi'
require 'base64'
require 'openssl'

class SsoController < ApplicationController
  SSO_KEY = AppConfig.church_online_platform.sso_key 
  
  before_filter :authenticate_user!
    
  def authenticate    
    user_hash = { 
      email: current_user.email, 
      expires: (Time.now.utc + 15.minutes).iso8601,
      first_name: current_user.first_name,
      last_name: current_user.last_name,
      nickname: current_user.first_name,
    }

    def encrypt(string, key) 
      Base64.encode64(aes(key, string)).gsub /\s/, '' 
    end 

    def aes(key, string)
      cipher = OpenSSL::Cipher::AES256.new(:CBC)
      cipher.encrypt 
      cipher.key  = Digest::SHA256.digest(key) 
      cipher.iv   = initialization_vector = cipher.random_iv 
      cipher_text = cipher.update(string) 
      cipher_text << cipher.final 
      return initialization_vector + cipher_text 
    end 

    encrypted_data    = encrypt(user_hash.to_json, SSO_KEY) 
    encoded_signature = Base64.encode64(OpenSSL::HMAC.digest('sha1', SSO_KEY, encrypted_data)) 
    
    sso       = CGI.escape(encrypted_data)
    signature = CGI.escape(encoded_signature)
    
    redirect_to "http://#{AppConfig.domains.live}/sso?sso=#{sso}&signature=#{signature}"
  end
end
