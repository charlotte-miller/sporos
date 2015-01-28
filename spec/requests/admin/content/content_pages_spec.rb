require 'rails_helper'

RSpec.describe "Pages", :type => :request do
  login_admin_user
  
  describe "GET /admin/content_pages" do
    it "works! (now write some real specs)" do
      get admin_content_pages_path
      expect(response).to have_http_status(200)
    end
  end
end
