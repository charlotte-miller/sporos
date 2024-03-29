require 'rails_helper'

describe GroupsController do
  before(:all) do
    @group = create(:group)
    @valid_attributes = attributes_for(:group)
  end

  let!(:group){ @group }
  let(:valid_attributes) { @valid_attributes }

  describe 'new or logged-out user' do

    describe "GET index" do
      let(:load_page!) { get :index, {} }

      it "loads" do
        load_page!
        should assign_to(:groups)
        should respond_with(:success)
      end

      it "assigns all groups as @groups" do
        load_page!
        should assign_to(:groups)
        assigns(:groups).should eq([group])
      end

      describe 'user_signed_in' do
        login_user

        let(:open_group) { FactoryGirl.build(:study_group) }
        let(:finished_group) { FactoryGirl.build(:study_group, state: 'is_finished') }

        before do
          FactoryGirl.create(:group_membership, group: open_group, member: current_user)
          FactoryGirl.create(:group_membership, group: finished_group, member: current_user)
        end

        it 'assigns groups associated with member when logged in' do
          load_page!
          should assign_to(:groups)
          assigns(:groups).should eq(current_user.groups)
        end

        it 'should assign to open_groups' do
          load_page!
          should assign_to(:open_groups)
          assigns(:open_groups).should eq([open_group])
        end

        it 'should assign to finished_groups' do
          load_page!
          should assign_to(:finished_groups)
          assigns(:finished_groups).should eq([finished_group])
        end
      end
    end

    describe "GET show" do
      let(:load_page!) { get :show, {:id => group.to_param} }

      it "loads" do
        load_page!
        should respond_with(:success)
      end


      it "assigns the requested group as @group" do
        load_page!
        assigns(:group).should eq(group)
      end
    end

    describe "trying to access logged_in content" do
      it ":new redirects to :index" do
        get :new, {}
        should redirect_to(new_user_session_url)
      end

      it ":show redirects to :index if a non-public group is attempted" do
        group = create(:group, is_public:false)
        get :show, {:id => group.to_param}
        should redirect_to(new_user_session_url)
      end

      it ":edit redirects to :index" do
        get :edit, { :id => group.to_param }
        should redirect_to(new_user_session_url)
      end

      it ":create redirects to :index" do
        post :create, {:group => valid_attributes}
        should redirect_to(new_user_session_url)
      end

      it ":update redirects to :index" do
        put :update, {:id => group.to_param, :group => { "name" => "MyString" }}
        should redirect_to(new_user_session_url)
      end

      it ":destroy redirects to :index" do
        delete :destroy, {:id => group.to_param}
        should redirect_to(new_user_session_url)
      end
    end

  end

  describe 'logged-in user' do
    login_user
    before(:each){  group.members << current_user }

    describe "GET index" do
      let(:load_page!) { get :index, {} }

      it "loads" do
        load_page!
        should respond_with(:success)
      end

      it "assigns all groups as @groups" do
        load_page!
        assigns(:groups).should eq([group])
      end

      it "scopes queries to the current_user" do
        load_page!
        skip
      end
    end

    describe "GET show" do
      let(:load_page!) { get :show, { :id => group.to_param } }

      it "loads" do
        load_page!
        should respond_with(:success)
      end


      it "assigns the requested @group and @membership" do
        load_page!
        assigns(:group).should eq(group)
        assigns(:membership).should eq(group.group_memberships.first)
      end

      it "scopes queries to the current_user" do
        skip
      end

      it "updates the users GroupMembership#last_attended_at" do
        Timecop.freeze('12/12/2012') { load_page! }
        current_user.membership_in(group.id).last_attended_at.should eql Time.parse('12/12/2012')
      end
    end

    describe "GET new" do
      it "loads" do
        get :new, {}
        should respond_with(:success)
      end


      it "assigns a new group as @group" do
        get :new, {}
        assigns(:group).should be_a_new(Group)
      end
    end

    describe "GET edit" do
      it "loads" do
        get :edit, { :id => group.to_param }
        should respond_with(:success)
      end


      it "assigns the requested group as @group" do
        get :edit, {:id => group.to_param}
        assigns(:group).should eq(group)
      end

      it "scopes queries to the current_user" do
        skip
      end
    end

    describe "POST create" do
      let(:valid_attributes) { build(:study_group).attributes }

      it "sets current_user as 'leader'" do
        skip
        # assigns(:group).leader.should eql current_user
      end

      describe "with valid params" do
        it "creates a new Group" do
          expect {
            post :create, { group: valid_attributes }
          }.to change(Group, :count).by(1)
        end

        it "assigns a newly created group as @group" do
          post :create, { group: valid_attributes }
          assigns(:group).should be_a(Group)
          assigns(:group).should be_persisted
        end

        it "redirects to the created group" do
          post :create, { group: valid_attributes }
          response.should redirect_to(Group.last.becomes(Group))
        end
      end

      describe "with invalid params" do
        describe 'with missing type' do
          it 'expects an argument error' do
            expect { post :create, { group: { type: {} } } }.to raise_error(ArgumentError)
          end
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Group.any_instance.stub(:save).and_return(false)
          post :create, { group: { "name" => "invalid value", type: 'Groups::StudyGroup' } }
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested group" do
          # Assuming there are no other groups in the database, this
          # specifies that the Group created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Group.any_instance.should_receive(:update_attributes).
            with({ "name" => "MyString", type: 'Groups::StudyGroup' })
          put :update, { id: group.to_param, group: { "name" => "MyString", type: 'Groups::StudyGroup' }}
        end

        it "assigns the requested group as @group" do
          put :update, {:id => group.to_param, :group => valid_attributes}
          assigns(:group).should eq(group)
        end

        it "redirects to the group" do
          put :update, {:id => group.to_param, :group => valid_attributes}
          response.should redirect_to(group.becomes(Group))
        end

        it "scopes updates to the current_user" do
          skip
        end
      end

      describe "with invalid params" do
        before :each do
          # Trigger the behavior that occurs when invalid params are submitted
          Group.any_instance.stub(:save).and_return(false)
          put :update, { id: group.to_param, group: { "name" => "invalid value", type: 'Groups::StudyGroup' }}
        end

        it "assigns the group as @group" do
          assigns(:group).should eq(group)
        end

        it "re-renders the 'edit' template" do
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested group" do
        expect {
          delete :destroy, {:id => group.to_param}
        }.to change(Group, :count).by(-1)
      end

      it "redirects to the groups list" do
        delete :destroy, {:id => group.to_param}
        response.should redirect_to(groups_url)
      end
    end

    it "scopes deletes to the current_user" do
      skip
    end
  end

  describe 'private methods' do

    describe '.safe_select_group' do

      it "rejects new or logged out users" do
        controller.stub('user_signed_in?'=>false )
        controller.send( :safe_select_group      )
        should_not assign_to(:groups)
        should_not assign_to(:group)
      end

      describe 'logged in users' do
        login_user
        let(:run_private_methods) { [:safe_select_groups, :safe_select_group].each {|meth| controller.send( meth ) } }
        # before(:each){  group.members << current_user }

        it "scopes @groups to the current user" do
          not_user_group = group
          user_group     = create(:group_w_member, new_member:@user)

          controller.params[:id] = user_group.id
          run_private_methods

          should assign_to(:groups)
          assigns(:groups).should     include(user_group)
          assigns(:groups).should_not include(not_user_group)

        end

        it "prevents horizontal privilage escilation from params[:id]" do
          not_user_group = group
          user_group     = create(:group_w_member, new_member:@user)

          controller.params[:id] = user_group
          run_private_methods

          should assign_to(:groups).with([user_group])
          should assign_to(:group).with(user_group)
        end
      end

    end

  end
end
