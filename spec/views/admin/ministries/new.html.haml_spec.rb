require 'rails_helper'

RSpec.describe "admin/ministries/new", :type => :view do
  before(:each) do
    assign(:ministry, Ministry.new(
      :name => "MyString",
      :description => "MyText",
    ))
    
    view.stub(:current_user) { User.new }
  end

  it "renders new ministry form" do
    render

    assert_select "form[action=?][method=?]", admin_ministries_path, "post" do

      assert_select "input#ministry_name[name=?]", "ministry[name]"

      assert_select "textarea#ministry_description[name=?]", "ministry[description]"
    end
  end
end
