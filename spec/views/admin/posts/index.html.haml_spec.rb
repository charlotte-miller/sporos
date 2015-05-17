require 'rails_helper'

RSpec.describe "admin/posts/index", :type => :view do
  before(:each) do
    Timecop.freeze do
      @expires = Time.now + 4.days
      
      @posts = assign(:posts, [
        build_stubbed(:post,
          :title => "MyText",
          :description => "MyText",
          :display_options => "",
          expired_at: @expires,
        ),
        build_stubbed(:post,
          :title => "MyText",
          :description => "MyText",
          :display_options => "",
          expired_at: @expires,
        )
      ])      
    end
  end

  it "renders a list of posts" do
    render
    assert_select ".title", :text => "MyText".to_s, :count => 2
    assert_select ".description", :text => "MyText".to_s, :count => 2
    assert_select '.thumbnail-img', :count => 2
    @posts.each {|post| assert_match  %r{/test/posts/links/#{post.id}/posters/sd.png}, rendered} 
    assert_select ".expires-in[data-expired-at='#{@expires.to_i}']", :count => 2
  end
end
