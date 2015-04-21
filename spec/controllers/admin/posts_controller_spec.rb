require 'rails_helper'

RSpec.describe Admin::PostsController, :type => :controller do
  login_admin_user #TODO: remove
  login_user
  
  before(:all) do
   @ministry = create(:populated_ministry)
   @ministry.leaders << @user
   @ministry.save!
   @editor   = @ministry.editors.first
   @volunteer= @ministry.volunteers.first
  end
  before(:each) { AWS.stub! }
  
  let(:valid_attributes) { attributes_for(:post, ministry:@ministry, author:@user, ministry_id:@ministry.id, user_id:@user.id, type:'Posts::Link') }

  let(:invalid_attributes) { {foo:'bar'} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PostsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all posts as @posts" do
      post = create(:post, ministry:@ministry, author:@user)
      get :index, {}, valid_session
      expect(assigns(:posts)).to eq([post])
    end
  end

  describe "GET show" do
    it "assigns the requested post as @post" do
      post = create(:post, ministry:@ministry, author:@user)
      get :show, {:id => post.to_param}, valid_session
      expect(assigns(:post)).to eq(post)
    end
  end

  describe "GET new" do
    it "assigns a new post as @post" do
      get :new, {}, valid_session
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe "GET edit" do
    it "assigns the requested post as @post" do
      post = create(:post, ministry:@ministry, author:@user)
      get :edit, {:id => post.to_param}, valid_session
      expect(assigns(:post)).to eq(post)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Post" do
        expect {
          post :create, {:post => valid_attributes}, valid_session
        }.to change(Post, :count).by(1)
      end

      it "assigns a newly created post as @post" do
        post :create, {:post => valid_attributes}, valid_session
        expect(assigns(:post)).to be_a(Post)
        expect(assigns(:post)).to be_persisted
      end

      it "redirects to the created post" do
        post :create, {:post => valid_attributes}, valid_session
        expect(response).to redirect_to(admin_post_url Post.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved post as @post" do
        post :create, {:post => invalid_attributes}, valid_session
        expect(assigns(:post)).to be_a_new(Post)
      end

      it "re-renders the 'new' template" do
        post :create, {:post => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested post" do
        post = create(:post, ministry:@ministry, author:@user)
        put :update, {:id => post.to_param, :post => new_attributes}, valid_session
        post.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested post as @post" do
        post = create(:post, ministry:@ministry, author:@user)
        put :update, {:id => post.to_param, :post => valid_attributes}, valid_session
        expect(assigns(:post)).to eq(post)
      end

      it "redirects to the post" do
        post = create(:post, ministry:@ministry, author:@user)
        put :update, {:id => post.to_param, :post => valid_attributes}, valid_session
        expect(response).to redirect_to(admin_post_url post)
      end
    end

    describe "with invalid params" do
      it "assigns the post as @post" do
        post = create(:post, ministry:@ministry, author:@user)
        put :update, {:id => post.to_param, :post => invalid_attributes}, valid_session
        expect(assigns(:post)).to eq(post)
      end

      it "re-renders the 'edit' template" do
        post = create(:post, ministry:@ministry, author:@user)
        put :update, {:id => post.to_param, :post => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested post" do
      post = create(:post, ministry:@ministry, author:@user)
      expect {
        delete :destroy, {:id => post.to_param}, valid_session
      }.to change(Post, :count).by(-1)
    end

    it "redirects to the posts list" do
      post = create(:post, ministry:@ministry, author:@user)
      delete :destroy, {:id => post.to_param}, valid_session
      expect(response).to redirect_to(admin_posts_url)
    end
  end

  describe "GET link_preview" do
    it "assigns all posts as @posts" do
      link = 'http://catalystconference.com/'
      expect(LinkThumbnailer).to receive(:generate).with(link)
      get :link_preview, {url:link}, valid_session
    end
  end

end
