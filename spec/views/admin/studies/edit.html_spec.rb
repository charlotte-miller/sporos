require 'rails_helper'

describe "admin/studies/edit" do
  before(:each) do
    @study = assign(:study, build_stubbed(:study,
      :slug => "MyString",
      :title => "MyString",
      :description => "MyString",
      :ref_link => "MyString",
      :created_at => Time.now
    ))
  end

  it "renders the edit studies form" do
    render

    assert_select "form", :action => admin_studies_path(@studies), :method => "post" do
      assert_select "input#media_study_slug",         :name => "media_studies[slug]"
      assert_select "input#media_study_title",        :name => "media_studies[title]"
      assert_select "input#media_study_description",  :name => "media_studies[description]"
      assert_select "input#media_study_ref_link",     :name => "media_studies[ref_link]"
      # assert_select "input#study_video_url", :name => "studies[video_url]"
    end
  end
end
