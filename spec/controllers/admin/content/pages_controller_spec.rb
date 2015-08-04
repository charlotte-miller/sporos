require 'rails_helper'

RSpec.describe Admin::Content::PagesController, :type => :controller do
  login_admin_user

  before(:all) do
    @valid_attributes = attributes_for(:page)
    @valid_session    = {}
  end

  let(:valid_attributes) { @valid_attributes }
  let(:invalid_attributes) { {title:'', body:''} }
  let(:valid_session)    { @valid_session }

  describe "GET index" do
    it "assigns all content_pages as @content_pages" do
      page = Page.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:pages)).to eq([page])
    end
  end

  describe "GET show" do
    it "assigns the requested content_page as @content_page" do
      page = Page.create! valid_attributes
      get :show, {:id => page.to_param}, valid_session
      expect(assigns(:page)).to eq(page)
    end
  end

  describe "GET new" do
    it "assigns a new content_page as @content_page" do
      get :new, {}, valid_session
      expect(assigns(:page)).to be_a_new(Page)
    end
  end

  describe "GET edit" do
    it "assigns the requested content_page as @content_page" do
      page = Page.create! valid_attributes
      get :edit, {:id => page.to_param}, valid_session
      expect(assigns(:page)).to eq(page)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Page" do
        expect {
          post :create, {:page => valid_attributes}, valid_session
        }.to change(Page, :count).by(1)
      end

      it "assigns a newly created content_page as @content_page" do
        post :create, {:page => valid_attributes}, valid_session
        expect(assigns(:page)).to be_a(Page)
        expect(assigns(:page)).to be_persisted
      end

      it "redirects to the created content_page" do
        post :create, {:page => valid_attributes}, valid_session
        expect(response).to redirect_to(admin_content_page_url(Page.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved content_page as @content_page" do
        post :create, {:page => invalid_attributes}, valid_session
        expect(assigns(:page)).to be_a_new(Page)
      end

      it "re-renders the 'new' template" do
        post :create, {:page => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested content_page" do
        page = Page.create! valid_attributes
        put :update, {:id => page.to_param, :page => new_attributes}, valid_session
        page.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested content_page as @content_page" do
        page = Page.create! valid_attributes
        put :update, {:id => page.to_param, :page => valid_attributes}, valid_session
        expect(assigns(:page)).to eq(page)
      end

      it "redirects to the content_page" do
        page = Page.create! valid_attributes
        put :update, {:id => page.to_param, :page => valid_attributes}, valid_session
        expect(response).to redirect_to(admin_content_page_url(page))
      end
    end

    describe "with invalid params" do
      it "assigns the content_page as @content_page" do
        page = Page.create! valid_attributes
        put :update, {:id => page.to_param, :page => invalid_attributes}, valid_session
        expect(assigns(:page)).to eq(page)
      end

      it "re-renders the 'edit' template" do
        page = Page.create! valid_attributes
        put :update, {:id => page.to_param, :page => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested content_page" do
      page = Page.create! valid_attributes
      expect {
        delete :destroy, {:id => page.to_param}, valid_session
      }.to change(Page, :count).by(-1)
    end

    it "redirects to the content_pages list" do
      page = Page.create! valid_attributes
      delete :destroy, {:id => page.to_param}, valid_session
      expect(response).to redirect_to(admin_content_pages_url)
    end
  end

end
