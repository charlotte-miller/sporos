require 'rails_helper'

RSpec.describe "Ministries", :type => :request do
  describe "GET /ministries" do
    it "works! (now write some real specs)" do
      get admin_ministries_path
      expect(response).to have_http_status(200)
    end
  end
end
