require 'rails_helper'

RSpec.describe "admin/ministries/index", :type => :view do
  before(:each) do
    assign(:ministries, [
     build_stubbed(:ministry,
        :name => "Name",
        :description => "MyText",
        :slug => "Url Path"
      ),
      build_stubbed(:ministry,
        :name => "Name",
        :description => "MyText",
        :slug => "Url Path"
      )
    ])
  end

  it "renders a list of ministries" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Url Path".to_s, :count => 2
  end
end
