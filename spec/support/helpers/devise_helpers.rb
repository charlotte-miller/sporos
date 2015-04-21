module Devise
  module ControllerHelper
    def login_user      
      before(:all) { @user = create(:user) }
      
      let(:current_user){ @user }
      before(:each) do       
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in @user                               
      end
    end                                                               
                                                                      
    def login_admin_user                                              
      before(:all) { @admin_user = create(:admin_user) }
      
      let(:current_admin_user){ @admin_user }
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in @admin_user
      end
    end
  end

  module RequestHelper
    def login_user
      before(:all) { @user = FactoryGirl.create :user }
      
      let(:current_user){ @user }
      before(:each) do
        post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password      
      end
    end
    
    def login_admin_user
      before(:all) { @admin_user = FactoryGirl.create :admin_user }
      
      let(:current_admin_user){ @admin_user }
      before(:each) do
        post_via_redirect user_session_path, 'user[email]' => @admin_user.email, 'user[password]' => @admin_user.password      
      end
    end
  end
end