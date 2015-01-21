require 'rails_helper'

RSpec.describe "admin/content/pages/edit", :type => :view do
  before(:each) do
    @content_page = assign(:content_page, Content::Page.create!(
      :slug => "mens_ministry",
      :title => "Men's Ministry",
      :body => "The Men's Ministry is for Men",
      :seo_keywords => "men"
    ))
  end

  it "renders the edit content_page form" do
    render

    assert_select "form[action=?][method=?]", admin_content_page_path(@content_page), "post" do

      assert_select "input#content_page_slug[name=?]", "content_page[slug]"

      assert_select "input#content_page_title[name=?]", "content_page[title]"

      assert_select "textarea#content_page_body[name=?]", "content_page[body]"

      assert_select "input#content_page_seo_keywords[name=?]", "content_page[seo_keywords]"
    end
  end
end
