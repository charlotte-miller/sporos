require 'rails_helper'

describe "groups/index" do
  before(:each) do
    assign(:groups, [
      stub_model(Group,
        :name => "Name",
        :description => "MyText",
        :created_at => Time.now
      ),
      stub_model(Group,
        :name => "Name",
        :description => "MyText",
        :created_at => Time.now
      )
    ])
  end

  xit "renders a list of groups" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
