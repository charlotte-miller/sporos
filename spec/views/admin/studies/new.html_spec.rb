require 'rails_helper'

describe "admin/studies/new" do
  before(:each) do
    assign(:study, stub_model(Media::Study,
      :slug => "MyString",
      :title => "MyString",
      :description => "MyString",
      :ref_link => "MyString",
      :created_at => Time.now
    ).as_new_record)
  end

  it "renders new study form" do
    render

    assert_select "form", :action => admin_studies_path, :method => "post" do
      assert_select "input#media_study_slug",         :name => "media_study[slug]"
      assert_select "input#media_study_title",        :name => "media_study[title]"
      assert_select "input#media_study_description",  :name => "media_study[description]"
      assert_select "input#media_study_ref_link",     :name => "media_study[ref_link]"
      # assert_select "input#study_video_url", :name => "study[video_url]"
    end
  end
end
