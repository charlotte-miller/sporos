require 'rails_helper'

RSpec.describe Admin::CommArtsRequestsController, :type => :controller do
  login_user

  describe "create" do
    it "creates a new comm arts request" do
      expect {
        post :create, { comm_arts_request: attributes_for(:comm_arts_request) }
      }.to change(CommArtsRequest, :count).by(1)
    end

    it 'should redirect back to index page' do
      post :create, { comm_arts_request: attributes_for(:comm_arts_request) }
      expect(response).to redirect_to(admin_comm_arts_requests_path)
    end
  end

  describe "GET index" do
    let!(:unarchived_requests) { FactoryGirl.create_list(:comm_arts_request, 3) }
    let!(:archived_requests) { FactoryGirl.create_list(:comm_arts_request, 3, archived_at: Time.now) }
    let!(:ministries) { Ministry.all.to_a }
    before :each do
      get 'index'
    end

    it "returns http success" do
      expect(response).to be_success
    end

    it 'assigns ministries' do
      expect(assigns(:ministries)).to eq(ministries)
    end

    xit 'assigns new request' do
      # TODO: Fix this
      expect(assigns(:new_request)).to eq(CommArtsRequest.new)
    end

    it 'assigns unarchived requests' do
      expect(assigns(:unarchived_requests)).to eq(unarchived_requests)
    end

    it 'assigns archived requests' do
      expect(assigns(:archived_requests)).to eq(archived_requests)
    end
  end

  describe 'toggle_archive' do
    let!(:request) { FactoryGirl.create(:comm_arts_request) }

    it 'should set the archived_at to something if value is nil' do
      get :toggle_archive, { id: request.id }
      expect(request.reload.archived_at).to be_present
    end

    it 'should set the archived_at to nil if value is present' do
      request.archived_at = Time.now; request.save
      get :toggle_archive, { id: request.id }
      expect(assigns(:request).reload.archived_at).to be_nil
    end
  end
end
