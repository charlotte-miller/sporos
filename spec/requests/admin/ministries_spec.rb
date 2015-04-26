require 'rails_helper'

RSpec.describe "Ministries", :type => :request do
  describe "GET /ministries" do
    login_user
    
    before(:all) do
      @ministry = create(:ministry)
      @ministry.leaders << @user
    end
    
    it "works! (now write some real specs)" do
      get admin_ministries_path
      expect(response).to redirect_to(admin_ministry_url(@ministry))
    end
  end
end
