require 'rails_helper'

RSpec.describe PostsController, :type => :controller do
  before(:each) { AWS.stub! }

  before(:all) do
    @ministry = create(:populated_ministry)
    @ministry_post, @other_post = @posts = [
      create(:post, published_at:Time.now-1.days, ministry:@ministry),
      create(:post, published_at:Time.now-2.days) ]
  end

  let(:valid_attributes) { {} }

  describe "GET index" do
    context 'COMBINED FEED' do
      it "assigns all posts as @posts" do
        get :index, valid_attributes
        expect(assigns(:posts).map(&:id)).to eq(@posts.map(&:id))
      end
    end

    context 'MINISTRY FEED' do
      let(:valid_attributes) { {ministry:@ministry.to_param} }

      it "assigns all posts as @posts" do
        get :index, valid_attributes
        expect(assigns(:posts)).to eq([@ministry_post])
      end
    end

  end

  describe "GET show" do
    it "assigns the requested post as @post" do
      get :show, {:id => @other_post.to_param}
      expect(assigns(:post)).to eq(@other_post)
    end
  end
end
