require 'rails_helper'

RSpec.describe "admin/posts/show", :type => :view do
  before(:each) do
    @post = assign(:post, build_stubbed(:post,
      :type => "MyText",
      :title => "MyText",
      :description => "MyText",
      :display_options => "",
      :poster => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
