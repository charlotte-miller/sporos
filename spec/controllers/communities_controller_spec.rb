require 'rails_helper'

RSpec.describe CommunitiesController, :type => :controller do

  describe "GET 'index'" do
    let!(:posts) { FactoryGirl.create_list(:post_event, 3, published_at: Time.now) }

    before :each do
      get 'index'
    end

    it "returns http success" do
      expect(response).to be_success
    end

    it 'expects published posts to be assigned' do
      expect(assigns(:posts).to_a).to eq(posts)
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', id:'men'
      expect(response).to be_success
    end
  end
end
