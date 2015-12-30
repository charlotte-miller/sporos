require 'rails_helper'

RSpec.describe Admin::UploadedFilesController, :type => :controller do
  login_user

  before(:all) do
    @ministry = create(:ministry_w_member, user:@user)
    @post     = create(:post_photo, ministry:@ministry, author:@user)
  end

  let(:valid_attributes) { attributes_for(:uploaded_file, from: @post) }
  let(:invalid_attributes) { {uploaded_file:{}} }
  let(:valid_session) {{}}

  describe 'GET index' do
    context 'NEW Post' do
      it "assigns all uploaded_files as @uploaded_files" do
        files = 2.times.map { create :uploaded_file, session_id:session.id }
        get :index, {}, valid_session
        expect(assigns(:uploaded_files)).to eq(files)
      end
    end

    context 'UPDATE Post' do
      it "assigns all uploaded_files as @uploaded_files" do
        files = @post.uploaded_files | 2.times.map { create :uploaded_file, from:@post}.reverse
        get :index, {post:{type:'Posts::Link', id:@post.id}}
        expect(assigns(:uploaded_files).map(&:id)).to eq(files.map(&:id))
      end
    end
  end

  describe "POST create" do
    it 'finds an existing @post' do

    end

    describe "with valid params" do
      it "creates a new UploadedFile" do
        expect {
          post :create, {:uploaded_file => valid_attributes}, valid_session
        }.to change(UploadedFile, :count).by(1)
      end

      it "assigns a newly created uploaded_file as @uploaded_file" do
        post :create, {:uploaded_file => valid_attributes}, valid_session
        expect(assigns(:uploaded_file)).to be_a(UploadedFile)
        expect(assigns(:uploaded_file)).to be_persisted
      end

      it "redirects to the created uploaded_file" do
        post :create, {:uploaded_file => valid_attributes}, valid_session
        expect(response.body).to eql( MultiJson.dump( {files:[ UploadedFile.last.file_as_json ]} ))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved uploaded_file as @uploaded_file" do
        post :create, {:uploaded_file => invalid_attributes}, valid_session
        expect(assigns(:uploaded_file)).to be_a_new(UploadedFile)
      end

      it "returns an error message for each errant file" do
        post :create, {:uploaded_file => invalid_attributes}, valid_session
        expect(MultiJson.load(response.body)['files'][0]['error']).to be_a Array
        expect(MultiJson.load(response.body)['files'][0]['error'][0]).to eql "File can't be blank"
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested uploaded_file" do
      uploaded_file = create(:uploaded_file, from:@post)
      expect {
        delete :destroy, {:id => uploaded_file.to_param}, valid_session
      }.to change(UploadedFile, :count).by(-1)
    end

    describe 'access control' do
      before(:each) do
        @user = create(:user) #current_user
        sign_in @user
      end

      it "allows the post's author" do
        @user = @post.author
        sign_in @user
        uploaded_file = create(:uploaded_file, from:@post)
        expect(delete :destroy, {:id => uploaded_file.to_param}, valid_session).to have_http_status(:success)
      end

      it "allows the current session" do
        uploaded_file = create(:uploaded_file, session_id:controller.session.id)
        expect(delete :destroy, {:id => uploaded_file.to_param}, valid_session).to have_http_status(:success)
      end

      it "allows the post's approvers " do
        @post.approvers << @user
        uploaded_file = create(:uploaded_file, from:@post)
        expect(delete :destroy, {:id => uploaded_file.to_param}, valid_session).to have_http_status(:success)
      end

      it 'allows an admin' do
        @user.update_attribute(:admin, true)
        uploaded_file = create(:uploaded_file, from:@post)
        expect(delete :destroy, {:id => uploaded_file.to_param}, valid_session).to have_http_status(:success)
      end

      it 'does NOT allow ' do
        uploaded_file = create(:uploaded_file, from:@post)
        expect(delete :destroy, {:id => uploaded_file.to_param}, valid_session).to redirect_to(admin_posts_url)
      end
    end

    it "returns true via JSON" do
      uploaded_file = create(:uploaded_file, from:@post)
      delete :destroy, {:id => uploaded_file.to_param}, valid_session
      expect(response.body).to eql MultiJson.dump({ files:[{
        uploaded_file.file.name => true
      }]})
    end
  end


end
