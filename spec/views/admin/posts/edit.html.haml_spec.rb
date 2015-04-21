require 'rails_helper'

RSpec.describe "admin/posts/edit", :type => :view do
  before(:each) do
    @post = assign(:post, build_stubbed(:post,
      :type => "MyText",
      :title => "MyText",
      :description => "MyText",
      :display_options => "",
      :poster => ""
    ))
  end

  it "renders the edit post form" do
    render

    assert_select "form[action=?][method=?]", admin_post_path(@post), "post" do

      assert_select "textarea#post_type[name=?]", "post[type]"

      assert_select "textarea#post_title[name=?]", "post[title]"

      assert_select "textarea#post_description[name=?]", "post[description]"

      assert_select "input#post_display_options[name=?]", "post[display_options]"

      assert_select "input#post_poster[name=?]", "post[poster]"
    end
  end
end
