require 'rails_helper'

RSpec.describe "admin/posts/new", :type => :view do
  before(:each) do
    assign(:post, Post.new(
      :type => "MyText",
      :title => "MyText",
      :description => "MyText",
      :display_options => "",
      :poster => ""
    ))
  end

  it "renders new post form" do
    render

    assert_select "form[action=?][method=?]", admin_posts_path, "post" do

      assert_select "textarea#post_type[name=?]", "post[type]"

      assert_select "textarea#post_title[name=?]", "post[title]"

      assert_select "textarea#post_description[name=?]", "post[description]"

      assert_select "input#post_display_options[name=?]", "post[display_options]"

      assert_select "input#post_poster[name=?]", "post[poster]"
    end
  end
end
