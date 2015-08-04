require 'rails_helper'

describe QuestionsController do
  login_user

  before(:all) do
    @study   = create(:study)
    @lesson  = create(:lesson, study_id:@study.id)
    @group   = create(:group)
    @meeting = create(:meeting, lesson:@lesson, group:@group)
    @valid_attributes = attributes_for(:question).merge(author: @user)
  end

  let!(:question) { create(:question, author:@user, source:@lesson, permanent_approver:nil) }
  let(:valid_attributes) { @valid_attributes }

  describe 'from Lesson' do
    let!(:study)  { @study }
    let!(:lesson) { @lesson }

    describe "GET index" do
      it "loads" do
        get :index, {study_id:study.id, lesson_id:lesson.id}
        is_expected.to respond_with(:success)
      end

      it "requires authentication" do
        sign_out current_user
        get :index, {study_id:study.id, lesson_id:lesson.id}
        is_expected.to redirect_to '/login'
      end

      it "assigns all questions as @questions" do
        get :index, {study_id:study.id, lesson_id:lesson.id}
        expect(assigns(:questions)).to eq([question])
      end
    end

    describe "GET show" do
      it "loads" do
        get :show, {study_id:study.id, lesson_id:lesson.id, :id => question.to_param}
        should respond_with(:success)
      end

      it "requires authentication" do
        sign_out current_user
        get :show, {study_id:study.id, lesson_id:lesson.id, :id => question.to_param}
        should redirect_to '/login'
      end

      it "assigns the requested question as @question" do
        get :show, {study_id:study.id, lesson_id:lesson.id, :id => question.to_param}
        assigns(:question).should eq(question)
      end
    end

    describe "GET new" do
      it "loads" do
        get :new, {study_id:study.id, lesson_id:lesson.id}
        should respond_with(:success)
      end

      it "requires authentication" do
        sign_out current_user
        get :index, {study_id:study.id, lesson_id:lesson.id}
        should redirect_to '/login'
      end

      it "assigns a new question as @question" do
        get :new, {study_id:study.id, lesson_id:lesson.id}
        assigns(:question).should be_a_new(Question)
      end
    end

    describe "POST create" do
      it "requires authentication" do
        sign_out current_user
        post :create, {study_id:study.id, lesson_id:lesson.id, :question => valid_attributes}
        should redirect_to '/login'
      end

      describe "with valid params" do
        it "creates a new Question" do
          expect {
            post :create, {study_id:study.id, lesson_id:lesson.id, :question => valid_attributes}
          }.to change(Question, :count).by(1)
        end

        it "assigns a newly created question as @question" do
          post :create, {study_id:study.id, lesson_id:lesson.id, :question => valid_attributes}
          assigns(:question).should be_a(Question)
          assigns(:question).should be_persisted
        end

        it "redirects to the created question" do
          post :create, {study_id:study.id, lesson_id:lesson.id, :question => valid_attributes}
          response.should redirect_to(assigns(:question))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved question as @question" do
          # Trigger the behavior that occurs when invalid params are submitted
          Question.any_instance.stub(:save).and_return(false)
          post :create, {study_id:study.id, lesson_id:lesson.id, :question => { "text" => "" }}
          assigns(:question).should be_a_new(Question)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Question.any_instance.stub(:save).and_return(false)
          post :create, {study_id:study.id, lesson_id:lesson.id, :question => { "text" => "" }}
          response.should render_template("new")
        end
      end
    end

    describe '#current_source' do
      it "should be a Lesson" do
        get :index, {study_id:study.id, lesson_id:lesson.id}
        controller.send(:current_source).should eql lesson
      end
    end
  end

  describe 'from Group' do
    let!(:group)   { @group }
    let!(:meeting) { @meeting }

    describe "GET index" do
      it "loads" do
        get :index, {group_id:group.id, meeting_id:meeting.id}
        should respond_with(:success)
      end

      it "requires authentication" do
        sign_out current_user
        get :index, {group_id:group.id, meeting_id:meeting.id}
        should redirect_to '/login'
      end

      it "assigns all questions as @questions" do
        get :index, {group_id:group.id, meeting_id:meeting.id}
        assigns(:questions).should eq([question])
      end
    end

    describe "GET show" do
      it "loads" do
        get :show, {group_id:group.id, meeting_id:meeting.id, :id => question.to_param}
        should respond_with(:success)
      end

      it "requires authentication" do
        sign_out current_user
        get :show, {group_id:group.id, meeting_id:meeting.id, :id => question.to_param}
        should redirect_to '/login'
      end

      it "assigns the requested question as @question" do
        get :show, {group_id:group.id, meeting_id:meeting.id, :id => question.to_param}
        assigns(:question).should eq(question)
      end
    end

    describe "GET new" do
      it "loads" do
        get :new, {group_id:group.id, meeting_id:meeting.id}
        should respond_with(:success)
      end

      it "requires authentication" do
        sign_out current_user
        get :new, {group_id:group.id, meeting_id:meeting.id}
        should redirect_to '/login'
      end

      it "assigns a new question as @question" do
        get :new, {group_id:group.id, meeting_id:meeting.id}
        assigns(:question).should be_a_new(Question)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "requires authentication" do
          sign_out current_user
          post :create, {group_id:group.id, meeting_id:meeting.id, :question => valid_attributes}
          is_expected.to redirect_to '/login'
        end

        it "creates a new Question" do
          expect {
            post :create, {group_id:group.id, meeting_id:meeting.id, :question => valid_attributes}
          }.to change(Question, :count).by(1)
        end

        it "assigns a newly created question as @question" do
          post :create, {group_id:group.id, meeting_id:meeting.id, :question => valid_attributes}
          expect( assigns(:question)).to be_a(Question)
          expect( assigns(:question)).to be_persisted
        end

        it "redirects to the created question" do
          post :create, {group_id:group.id, meeting_id:meeting.id, :question => valid_attributes}
          expect(response).to redirect_to(assigns(:question))
        end
      end

      describe "with invalid params" do
        it "requires authentication" do
          sign_out current_user
          post :create, {group_id:group.id, meeting_id:meeting.id, :question => {"text" => "" } }
          should redirect_to '/login'
        end

        it "assigns a newly created but unsaved question as @question" do
          # Trigger the behavior that occurs when invalid params are submitted
          Question.any_instance.stub(:save).and_return(false)
          post :create, {group_id:group.id, meeting_id:meeting.id, :question => { "text" => "" }}
          assigns(:question).should be_a_new(Question)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Question.any_instance.stub(:save).and_return(false)
          post :create, {group_id:group.id, meeting_id:meeting.id, :question => { "text" => "" }}
          response.should render_template("new")
        end
      end
    end

    describe '#current_source' do
      it "should be a Meeting" do
        get :index, {group_id:group.id, meeting_id:meeting.id}
        controller.send(:current_source).should eql meeting
      end

      skip "MUST belong to the current_user" do
        # "something like: return current_user.meetings.find( params.delete(:meeting_id) ) if params[:meeting_id]"
        # could also use something like:
        # current_user.group_memberships.map(&:group_id).include? params[:group_id]
        # but we should check the users rights to a given meeting not just group :(
      end
    end
  end

  # describe 'prevent horizontal privalage escalation' do
  #   it "should only return questions a user has access to" do
  #     skip('not sure weather to go back to nesting (user has ownership of upstream info)
  #              or create a query for checking a users privlages') # leaning toward nesting
  #   end
  # end

  # describe 'private methods' do
  #   describe 'before_filters' do
  #
  #     describe '#merge_author_and_source' do
  #       skip
  #     end
  #
  #   end
  #
  # end
end
