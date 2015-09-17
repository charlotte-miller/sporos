require 'rails_helper'

RSpec.describe SsoController, :type => :controller do

  describe "GET authenticate" do
    context 'logged out' do
      it "redirects you to login" do
        get :authenticate
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_url
      end
    end
    
    context 'logged in' do
      login_user
      
      it "redirects you to the church online platform with 'sso' and 'signature' params" do
        get :authenticate
        uri    = URI.parse(response.location)
        params = CGI::parse(uri.query)
        expect(response).to have_http_status(302)
        expect(uri.host).to eql 'live.cornerstonesf.org'
        expect(params['sso']).not_to be_nil
        expect(params['signature']).not_to be_nil
      end
    end
  end
end
