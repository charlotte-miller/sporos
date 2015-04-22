require 'rails_helper'

RSpec.describe "admin/ministries/show", :type => :view do
  before(:each) do
    @ministry = assign(:ministry, build_stubbed(:ministry,
      :name => "Name",
      :description => "MyText",
      :slug => "Url Path"
    ))
    @posts = assign(:posts, 3.times.map {build_stubbed(:post)})
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Url Path/)
  end
end
