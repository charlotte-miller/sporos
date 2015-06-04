require 'rails_helper'

RSpec.describe "admin/posts/show", :type => :view do
  include PostsHelper
  
  before(:each) do
    @post = assign(:post, build_stubbed(:post,
      :title => "MyText",
      :description => "MyText",
      :poster => "",
      :url => 'http://www.thevillagechurch.net/resources/sermons/series/james/',
    ))
    # @type = assign(:type, post_type_of(@post))
    
    view.stub(:current_user) { User.new }
  end

  it "renders attributes" do
    render
    expect(rendered).to match(%r{http://www.thevillagechurch.net/resources/sermons/series/james/})
  end
end
