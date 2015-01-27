require 'rails_helper'

describe "admin/lessons/edit" do
  before(:each) do
    @lesson = assign(:lesson, stub_model(Media::Lesson,
      :study_id => 1,
      :position => 1,
      :title => "MyString",
      :description => "MyText",
      :backlink => "",
      :video => video_file,
      :audio => audio_file,
      :created_at => Time.now
    ))
  end

  it "renders the edit lesson form" do
    render

    assert_select "form", :action => admin_lessons_path(@lesson), :method => "post" do
      assert_select "input#media_lesson_study_id",        :name => "media_lesson[study_id]"
      assert_select "input#media_lesson_position",        :name => "media_lesson[position]"
      assert_select "input#media_lesson_title",           :name => "media_lesson[title]"
      assert_select "textarea#media_lesson_description",  :name => "media_lesson[description]"
      assert_select "input#media_lesson_backlink",        :name => "media_lesson[backlink]"
      assert_select "input#media_lesson_video",           :name => "media_lesson[video]"
      assert_select "input#media_lesson_audio",           :name => "media_lesson[audio]"
    end
  end
end
