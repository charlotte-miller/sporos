require 'rails_helper'

RSpec.describe Admin::PostsController, :type => :controller do
  login_user

  before(:all) do
   @ministry = create(:populated_ministry)
   @ministry.leaders << @user
   @ministry.save!
   @editor   = @ministry.editors.first
   @volunteer= @ministry.volunteers.first
  end
  before(:each) { AWS.stub! }

  let(:valid_attributes) { attributes_for(:post_link, ministry:@ministry, author:@user, ministry_id:@ministry.id, user_id:@user.id ) }

  let(:invalid_attributes) { {type:'Posts::Link', title:''} }

  let(:valid_session) { {} }

  describe "GET index" do
    describe 'assigns to @grouped_posts' do
      before(:all) do
        @my_recently_approved_posts = [create(:post, ministry:@ministry, author:@user, published_at:5.minutes.ago)]
        @i_should_approve           = [create(:post, ministry:@ministry, author:@volunteer)]
        @my_rejected_posts          = [create(:post, ministry:@ministry, author:@user, rejected_at:5.minutes.ago)]
        @my_pending_posts           = [create(:post, ministry:@ministry, author:@user)]
      end

      before(:each) { get :index, {}, valid_session }

      it 'includes "Recently Published" posts' do
        expect(assigns(:grouped_posts)['Recently Published'].to_ary).to eq(@my_recently_approved_posts)
      end

      it 'includes "Approval Required" posts' do
        expect(assigns(:grouped_posts)['Approval Required'].to_ary).to eq(@i_should_approve)
      end

      it 'includes "Rejected Posts" posts' do
        expect(assigns(:grouped_posts)['Rejected Posts'].to_ary).to eq(@my_rejected_posts)
      end

      it 'includes "Pending Posts" posts' do
        expect(assigns(:grouped_posts)['Pending Posts'].to_ary).to eq(@my_pending_posts)
      end

      it 'adds post.unread_comment_count' do
        assigns(:grouped_posts).values.flatten.each do |post|
          expect(post.unread_comment_count).to_not be_nil
        end
      end
    end
  end

  describe "GET show" do
    let(:post) { create(:post, ministry:@ministry, author:@user) }

    describe 'assigns' do
      before(:each) do
        get :show, {:id => post.to_param}, valid_session
      end

      it "@post" do
        expect(assigns(:post)).to eq(post)
      end

      it '@approval_statuses' do
        expect(assigns(:approval_statuses)).to eq(assigns(:current_users_approval_request).current_concensus(:mark_author))
      end

      it '@comments' do
        expect(assigns(:comments)).to eq(post.comment_threads)
      end

      it '@current_users_approval_request' do
        expect(assigns(:current_users_approval_request)).to eq(ApprovalRequest.find_by( user:@user, post:post ))
      end

      it '@approvers' do
        expect(assigns(:approvers)).to eq(post.approvers - [@user])
      end

      it '@comments_data' do
        expect(assigns(:comments_data)).to eq(controller.comments_data)
      end
    end

    context 'author is an editor' do
      before(:all) { @user = @editor } #login_user this user
      let(:post) { create(:post, ministry:@ministry, author:@editor) }

      it 'does not throw an error' do
        expect(lambda { get :show, {:id => post.to_param}, valid_session }).not_to raise_error
      end
    end
  end

  describe "GET new" do
    it "assigns a new post as @post" do
      get :new, {post_type:'link'}, valid_session
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

    describe '#safe_ministry_id' do
      it 'sets the ministry_id if the user has 1 ministry' do
        post :create, {:post => valid_attributes.merge({ministry_id:'whatever'}), format: :html}, valid_session
        expect(Post.last.ministry).to eq(@ministry)
        expect(response).to redirect_to(admin_post_url Post.last)
      end

      describe 'users with multiple ministries' do
        before(:each) do
          @other_ministry = create(:ministry)
          @other_ministry.leaders << @user
        end

        it 'returns params[:ministry_id] IF the current_user is involved in the ministry' do
          post :create, {:post => valid_attributes.merge({ministry_id:@other_ministry.id}), format: :html}, valid_session
          expect(Post.last.ministry).to eq(@other_ministry)
          expect(response).to redirect_to(admin_post_url Post.last)
        end

        it 'returns an error if the current_user is not involved with the ministry' do
          post :create, {:post => valid_attributes.merge({ministry_id:@other_ministry.id+10}), format: :html}, valid_session
          expect(assigns(:post).errors.full_messages).to eql ["Ministry can't be blank"]
          expect(response).to render_template("new")
        end

      end
    end

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
        post :create, {:post => valid_attributes, format: :html}, valid_session
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
        valid_attributes.merge( {title: "New Title of Wonders"} )
      }

      it "updates the requested post" do
        post = create(:post, ministry:@ministry, author:@user)
        put :update, {:id => post.to_param, :post => new_attributes}, valid_session
        post.reload
        expect(post.title).to eq('New Title of Wonders')
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
        put :update, {:id => post.to_param, :post => invalid_attributes, post_type:'link', post: {display_options: {poster_alternatives:[]}}}, valid_session
        expect(assigns(:post)).to eq(post)
      end

      it "re-renders the 'edit' template" do
        post = create(:post, ministry:@ministry, author:@user)
        put :update, {:id => post.to_param, :post => invalid_attributes, post_type:'link', post: {display_options: {poster_alternatives:[]}}}, valid_session
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
      expect(LinkThumbnailer).to receive(:generate).with(link, {:image_stats=>"true"})
      get :link_preview, {url:link}, valid_session
    end
  end

end
