require 'rails_helper'


RSpec.describe Admin::FaqAnswersController, :type => :controller do
  login_admin_user

  before(:all) do
    @valid_attributes = attributes_for(:faq_answer)
  end

  let!(:study) { @study }
  let!(:lesson){ @lesson}
  let(:valid_attributes){ @valid_attributes }

  let(:invalid_attributes) { {body:''} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Admin::FaqAnswersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all faq_answers as @faq_answers" do
      faq_answer = FaqAnswer.create! valid_attributes
      get :index, {}
      expect(assigns(:faq_answers)).to eq([faq_answer])
    end
  end

  describe "GET show" do
    it "assigns the requested faq_answer as @faq_answer" do
      faq_answer = FaqAnswer.create! valid_attributes
      get :show, {:id => faq_answer.to_param}
      expect(assigns(:faq_answer)).to eq(faq_answer)
    end
  end

  describe "GET new" do
    it "assigns a new faq_answer as @faq_answer" do
      get :new, {}
      expect(assigns(:faq_answer)).to be_a_new(FaqAnswer)
    end
  end

  describe "GET edit" do
    it "assigns the requested faq_answer as @faq_answer" do
      faq_answer = FaqAnswer.create! valid_attributes
      get :edit, {:id => faq_answer.to_param}
      expect(assigns(:faq_answer)).to eq(faq_answer)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new FaqAnswer" do
        expect {
          post :create, {:faq_answer => valid_attributes}
        }.to change(FaqAnswer, :count).by(1)
      end

      it "assigns a newly created faq_answer as @faq_answer" do
        post :create, {:faq_answer => valid_attributes}
        expect(assigns(:faq_answer)).to be_a(FaqAnswer)
        expect(assigns(:faq_answer)).to be_persisted
      end

      it "redirects to the created faq_answer" do
        post :create, {:faq_answer => valid_attributes}
        expect(response).to redirect_to([:admin, FaqAnswer.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved faq_answer as @faq_answer" do
        post :create, {:faq_answer => invalid_attributes}
        expect(assigns(:faq_answer)).to be_a_new(FaqAnswer)
      end

      it "re-renders the 'new' template" do
        post :create, {:faq_answer => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_body) { 'When the food is hot the conversation is not.' }
      let(:new_attributes) { {body:new_body} }

      it "updates the requested faq_answer" do
        faq_answer = FaqAnswer.create! valid_attributes
        put :update, {:id => faq_answer.to_param, :faq_answer => new_attributes}
        faq_answer.reload
        expect(faq_answer.body).to eq(new_body)
      end

      it "assigns the requested faq_answer as @faq_answer" do
        faq_answer = FaqAnswer.create! valid_attributes
        put :update, {:id => faq_answer.to_param, :faq_answer => valid_attributes}
        expect(assigns(:faq_answer)).to eq(faq_answer)
      end

      it "redirects to the faq_answer" do
        faq_answer = FaqAnswer.create! valid_attributes
        put :update, {:id => faq_answer.to_param, :faq_answer => valid_attributes}
        expect(response).to redirect_to([:admin, faq_answer])
      end
    end

    describe "with invalid params" do
      it "assigns the faq_answer as @faq_answer" do
        faq_answer = create(:faq_answer)
        put :update, {:id => faq_answer.to_param, :faq_answer => invalid_attributes}
        expect(assigns(:faq_answer)).to eq(faq_answer)
      end

      it "re-renders the 'edit' template" do
        faq_answer = create(:faq_answer)
        put :update, {:id => faq_answer.to_param, :faq_answer => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested faq_answer" do
      faq_answer = FaqAnswer.create! valid_attributes
      expect {
        delete :destroy, {:id => faq_answer.to_param}
      }.to change(FaqAnswer, :count).by(-1)
    end

    it "redirects to the faq_answers list" do
      faq_answer = FaqAnswer.create! valid_attributes
      delete :destroy, {:id => faq_answer.to_param}
      expect(response).to redirect_to(admin_faq_answers_url)
    end
  end

end
