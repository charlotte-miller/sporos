require 'rails_helper'

RSpec.describe Admin::MinistriesController, :type => :controller do
  login_admin_user

  before(:all) do
    AWS.stub!
    @valid_attributes = attributes_for(:ministry)
  end

  let(:valid_attributes){ @valid_attributes }

  let(:invalid_attributes) { {name:'', description:''} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MinistriesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all ministries as @ministries" do
      ministry = Ministry.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:ministries)).to eq([ministry])
    end
  end

  describe "GET new" do
    it "assigns a new ministry as @ministry" do
      get :new, {}, valid_session
      expect(assigns(:ministry)).to be_a_new(Ministry)
    end
  end

  describe "GET edit" do
    it "assigns the requested ministry as @ministry" do
      ministry = Ministry.create! valid_attributes
      get :edit, {:id => ministry.to_param}, valid_session
      expect(assigns(:ministry)).to eq(ministry)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Ministry" do
        expect {
          post :create, {:ministry => valid_attributes}, valid_session
        }.to change(Ministry, :count).by(1)
      end

      it "assigns a newly created ministry as @ministry" do
        post :create, {:ministry => valid_attributes}, valid_session
        expect(assigns(:ministry)).to be_a(Ministry)
        expect(assigns(:ministry)).to be_persisted
      end

      it "redirects to the created ministry" do
        post :create, {:ministry => valid_attributes}, valid_session
        expect(response).to redirect_to(admin_ministry_url Ministry.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved ministry as @ministry" do
        post :create, {:ministry => invalid_attributes}, valid_session
        expect(assigns(:ministry)).to be_a_new(Ministry)
      end

      it "re-renders the 'new' template" do
        post :create, {:ministry => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested ministry" do
        ministry = Ministry.create! valid_attributes
        put :update, {:id => ministry.to_param, :ministry => new_attributes}, valid_session
        ministry.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested ministry as @ministry" do
        ministry = Ministry.create! valid_attributes
        put :update, {:id => ministry.to_param, :ministry => valid_attributes}, valid_session
        expect(assigns(:ministry)).to eq(ministry)
      end

      it "redirects to the ministry" do
        ministry = Ministry.create! valid_attributes
        put :update, {:id => ministry.to_param, :ministry => valid_attributes}, valid_session
        expect(response).to redirect_to(admin_ministry_url ministry)
      end
    end

    describe "with invalid params" do
      it "assigns the ministry as @ministry" do
        ministry = Ministry.create! valid_attributes
        put :update, {:id => ministry.to_param, :ministry => invalid_attributes}, valid_session
        expect(assigns(:ministry)).to eq(ministry)
      end

      it "re-renders the 'edit' template" do
        ministry = Ministry.create! valid_attributes
        put :update, {:id => ministry.to_param, :ministry => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested ministry" do
      ministry = Ministry.create! valid_attributes
      expect {
        delete :destroy, {:id => ministry.to_param}, valid_session
      }.to change(Ministry, :count).by(-1)
    end

    it "redirects to the ministries list" do
      ministry = Ministry.create! valid_attributes
      delete :destroy, {:id => ministry.to_param}, valid_session
      expect(response).to redirect_to(admin_ministries_url)
    end
  end

end
