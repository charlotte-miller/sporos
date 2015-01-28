require 'rails_helper'

RSpec.describe "admin/content/pages/new", :type => :view do
  before(:each) do
    assign(:page, Page.new(
      :slug => "MyString",
      :title => "MyString",
      :body => "MyText",
      :seo_keywords => ""
    ))
  end

  it "renders new page form" do
    render

    assert_select "form[action=?][method=?]", admin_content_pages_path, "post" do

      assert_select "input#page_slug[name=?]", "page[slug]"

      assert_select "input#page_title[name=?]", "page[title]"

      assert_select "textarea#page_body[name=?]", "page[body]"

      assert_select "input#page_seo_keywords[name=?]", "page[seo_keywords]"
    end
  end
end
