require 'rails_helper'

RSpec.describe "Posts", :type => :request do
  describe "GET /posts" do
    login_admin_user
    
    it "works! (now write some real specs)" do
      get admin_posts_path
      expect(response).to have_http_status(200)
    end
  end
end
