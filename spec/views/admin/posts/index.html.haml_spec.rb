require 'rails_helper'

RSpec.describe "admin/posts/index", :type => :view do
  before(:each) do
    Timecop.freeze do
      @expires = Time.now + 4.days

      @posts = assign(:posts, [
        build_stubbed(:post,
          :title => "MyText",
          :description => "MyText",
          :display_options => {},
          expired_at: @expires,
        ),
        build_stubbed(:post,
          :title => "MyText",
          :description => "MyText",
          :display_options => {},
          expired_at: @expires,
        )
      ])

      @posts.each(&:generate_missing_public_id)
    end

    @grouped_posts = assign :grouped_posts, {
      "Recently Published" => @posts,
      "Approval Required"  => [],
      "Rejected Posts"     => [],
      "Pending Posts"      => [],
    }

    view.stub(:current_user) { User.new(first_name:'Fred', last_name:'Fredrickson') }
  end

  it "renders a list of posts" do
    render
    assert_select ".title", :text => "MyText".to_s, :count => 2
    @posts.each {|post| assert_match  %r{#{admin_post_path(post)}}, rendered}
  end
end
