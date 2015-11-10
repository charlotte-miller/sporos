require 'rails_helper'

RSpec.describe SearchSessionsController, :type => :controller do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET show" do
    it "assigns the requested search_session as @search_session" do
      search_session = SearchSession.create! valid_attributes
      get :show, {:id => search_session.to_param}, valid_session
      expect(assigns(:search_session)).to eq(search_session)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new SearchSession" do
        expect {
          post :create, {:search_session => valid_attributes}, valid_session
        }.to change(SearchSession, :count).by(1)
      end

      it "assigns a newly created search_session as @search_session" do
        post :create, {:search_session => valid_attributes}, valid_session
        expect(assigns(:search_session)).to be_a(SearchSession)
        expect(assigns(:search_session)).to be_persisted
      end

      it "redirects to the created search_session" do
        post :create, {:search_session => valid_attributes}, valid_session
        expect(response).to redirect_to(SearchSession.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved search_session as @search_session" do
        post :create, {:search_session => invalid_attributes}, valid_session
        expect(assigns(:search_session)).to be_a_new(SearchSession)
      end

      it "re-renders the 'new' template" do
        post :create, {:search_session => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested search_session" do
        search_session = SearchSession.create! valid_attributes
        put :update, {:id => search_session.to_param, :search_session => new_attributes}, valid_session
        search_session.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested search_session as @search_session" do
        search_session = SearchSession.create! valid_attributes
        put :update, {:id => search_session.to_param, :search_session => valid_attributes}, valid_session
        expect(assigns(:search_session)).to eq(search_session)
      end

      it "redirects to the search_session" do
        search_session = SearchSession.create! valid_attributes
        put :update, {:id => search_session.to_param, :search_session => valid_attributes}, valid_session
        expect(response).to redirect_to(search_session)
      end
    end

    describe "with invalid params" do
      it "assigns the search_session as @search_session" do
        search_session = SearchSession.create! valid_attributes
        put :update, {:id => search_session.to_param, :search_session => invalid_attributes}, valid_session
        expect(assigns(:search_session)).to eq(search_session)
      end

      it "re-renders the 'edit' template" do
        search_session = SearchSession.create! valid_attributes
        put :update, {:id => search_session.to_param, :search_session => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  # describe '[private] current_search' do
  #   before(:each) { controller.instance_variable_set(:@feedback_params, {current_search:'food', result_count:12}) }
  #   let(:existing_search) { Searchjoy::Search.create(query:'foo', rails_session_id:controller.session.id) }
  #
  #   it 'creates a Searchjoy::Search if none exists' do
  #     expect(lambda { controller.bypass.current_search }).to change(Searchjoy::Search, :count).by(1)
  #   end
  #
  #   it 'finds an existing Search by session' do
  #     existing_search
  #     expect(controller.bypass.current_search).to eq(existing_search)
  #   end
  #
  #   it 'creates a new Search if the last Search was is more then a minute old' do
  #     Timecop.travel(2.minutes.ago) { existing_search }
  #     expect(controller.bypass.current_search).not_to eq(existing_search)
  #   end
  # end
end
