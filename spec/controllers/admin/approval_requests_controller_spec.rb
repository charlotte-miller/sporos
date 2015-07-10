require 'rails_helper'

RSpec.describe Admin::ApprovalRequestsController, :type => :controller do
  before(:all) do
    @ministry = create(:populated_ministry)
    @user = @ministry.members.first
    @post = create(:post, ministry:@ministry, author: @user)
  end

  login_user

  before(:each) do
    @approval_request = @post.approval_requests.where(user_id: @user.id).first
  end

  let(:comment_threads_attributes) { [attributes_for(:comment, commentable: @approval_request)] }

  describe "PUT update" do
    it 'should notify all people involve when a new comment is made' do
      params = { id: @approval_request.id, approval_request: {comment_threads_attributes: comment_threads_attributes} }
      expect(ApprovalRequestCommentMailer).to receive(:notify_all).and_call_original
      put :update, params
    end

    it 'should not send an email on an empty comment body' do
      comment_threads_attributes.first.merge!(body: nil)
      params = { id: @approval_request.id, approval_request: {comment_threads_attributes: comment_threads_attributes} }
      expect(ApprovalRequestCommentMailer).to_not receive(:notify_all)
      put :update, params
    end
  end

  describe 'update status from link' do
    before(:each) do
      @approval_request.pending!
    end

    it 'should update the status based on the link params' do
      get :update_status_from_link, { id: @approval_request.id, commit: 'Approve' }
      expect(assigns(:approval_request)).to be_accepted

      get :update_status_from_link, { id: @approval_request.id, commit: 'Reject' }
      expect(assigns(:approval_request)).to be_rejected
    end

    it 'should raise an argument error if there are no commit params' do
      expect {
        get :update_status_from_link, { id: @approval_request.id }
      }.to raise_error(ArgumentError)
    end

    it 'should redirect to the admin/post/show' do
      get :update_status_from_link, { id: @approval_request.id, commit: 'Approve' }
      expect(response).to redirect_to(admin_post_url(@post))
    end
  end

  # skip 'TODO'

  # before(:all) do
  #   AWS.stub!
  #   @valid_attributes = attributes_for(:ministry)
  # end
  #
  # let(:valid_attributes){ @valid_attributes }
  #
  # let(:invalid_attributes) { {name:'', description:''} }
  #
  # let(:valid_session) { {} }
  #
  # describe "PUT update" do
  #   describe "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }
  #
  #     it "updates the requested ministry" do
  #       ministry = Ministry.create! valid_attributes
  #       put :update, {:id => ministry.to_param, :ministry => new_attributes}, valid_session
  #       ministry.reload
  #       skip("Add assertions for updated state")
  #     end
  #
  #     it "assigns the requested ministry as @ministry" do
  #       ministry = Ministry.create! valid_attributes
  #       put :update, {:id => ministry.to_param, :ministry => valid_attributes}, valid_session
  #       expect(assigns(:ministry)).to eq(ministry)
  #     end
  #
  #     it "redirects to the ministry" do
  #       ministry = Ministry.create! valid_attributes
  #       put :update, {:id => ministry.to_param, :ministry => valid_attributes}, valid_session
  #       expect(response).to redirect_to(admin_ministry_url ministry)
  #     end
  #   end
  #
  #   describe "with invalid params" do
  #     it "assigns the ministry as @ministry" do
  #       ministry = Ministry.create! valid_attributes
  #       put :update, {:id => ministry.to_param, :ministry => invalid_attributes}, valid_session
  #       expect(assigns(:ministry)).to eq(ministry)
  #     end
  #
  #     it "re-renders the 'edit' template" do
  #       ministry = Ministry.create! valid_attributes
  #       put :update, {:id => ministry.to_param, :ministry => invalid_attributes}, valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end


end
