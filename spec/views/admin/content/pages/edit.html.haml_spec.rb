require 'rails_helper'

RSpec.describe "admin/content/pages/edit", :type => :view do
  before(:each) do
    @page = assign(:page, build_stubbed(:page,
      :slug => "mens_ministry",
      :title => "Men's Ministry",
      :body => "The Men's Ministry is for Men",
      :seo_keywords => "men"
    ))
  end

  it "renders the edit page form" do
    render

    assert_select "form[action=?][method=?]", admin_content_page_path(@page), "post" do
      assert_select "input#page_slug[name=?]", "page[slug]"
      assert_select "input#page_title[name=?]", "page[title]"
      assert_select "textarea#page_body[name=?]", "page[body]"
      assert_select "input#page_seo_keywords[name=?]", "page[seo_keywords]"
    end
  end
end
