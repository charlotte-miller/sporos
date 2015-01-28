require 'rails_helper'

RSpec.describe "admin/content/pages/show", :type => :view do
  before(:each) do
    @page = assign(:page, build_stubbed(:page,
      :slug => "Slug",
      :title => "Title",
      :body => "MyText",
      :seo_keywords => ["foo", "bar"]
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/foo, bar/)
  end
end
