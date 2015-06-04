require 'rails_helper'

RSpec.describe "admin/posts/show", :type => :view do
  include PostsHelper
  
  before(:each) do
    @post = assign(:post, build_stubbed(:post,
      :title => "MyText",
      :description => "MyText",
      :display_options => {},
      :poster => ""
    ))
    # @type = assign(:type, post_type_of(@post))
    
    view.stub(:current_user) { User.new }
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
  end
end
