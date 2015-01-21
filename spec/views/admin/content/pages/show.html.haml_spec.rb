require 'rails_helper'

RSpec.describe "admin/content/pages/show", :type => :view do
  before(:each) do
    @content_page = assign(:content_page, Content::Page.create!(
      :slug => "Slug",
      :title => "Title",
      :body => "MyText",
      :seo_keywords => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
