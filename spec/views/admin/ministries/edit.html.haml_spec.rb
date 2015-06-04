require 'rails_helper'

RSpec.describe "admin/ministries/edit", :type => :view do
  before(:each) do
    @ministry = assign(:ministry, build_stubbed(:ministry,
      :name => "MyString",
      :description => "MyText",
    ))
    
    view.stub(:current_user) { User.new }
  end

  it "renders the edit ministry form" do
    render

    assert_select "form[action=?][method=?]", admin_ministry_path(@ministry), "post" do

      assert_select "input#ministry_name[name=?]", "ministry[name]"

      assert_select "textarea#ministry_description[name=?]", "ministry[description]"

    end
  end
end
