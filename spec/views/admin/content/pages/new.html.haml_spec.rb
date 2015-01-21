require 'rails_helper'

RSpec.describe "admin/content/pages/new", :type => :view do
  before(:each) do
    assign(:content_page, Content::Page.new(
      :slug => "MyString",
      :title => "MyString",
      :body => "MyText",
      :seo_keywords => ""
    ))
  end

  it "renders new content_page form" do
    render

    assert_select "form[action=?][method=?]", admin_content_pages_path, "post" do

      assert_select "input#content_page_slug[name=?]", "content_page[slug]"

      assert_select "input#content_page_title[name=?]", "content_page[title]"

      assert_select "textarea#content_page_body[name=?]", "content_page[body]"

      assert_select "input#content_page_seo_keywords[name=?]", "content_page[seo_keywords]"
    end
  end
end
