require 'rails_helper'

RSpec.describe "admin/content/pages/index", :type => :view do
  before(:each) do
    @pages = assign(:pages, [
      build_stubbed(:page,
        :slug => "foo",
        :title => "Title",
        :body => "MyText",
        :seo_keywords => %w{foo bar}
      ),
      build_stubbed(:page,
        :slug => "bar",
        :title => "Title",
        :body => "MyText",
        :seo_keywords => %w{foo bar}
      )
    ])
  end

  it "renders a list of admin/content/pages" do
    render
    @pages.map(&:slug).each do |slug|
      assert_select "tr>td", :text => slug,     :count => 1
    end
    assert_select "tr>td", :text => "Title",    :count => 2
    assert_select "tr>td", :text => "MyText",   :count => 2
    assert_select "tr>td", :text => "foo, bar", :count => 2
  end
end
