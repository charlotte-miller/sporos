require 'rails_helper'

describe "admin/lessons/show" do
  before(:each) do
    @audio, @video = [audio_file, video_file]
    @lesson = assign(:lesson, build_stubbed(:lesson,
      :title => "Road to Damascus Part 1",
      :description => "God famously meets us in the low places.  This is a study on God intersecting our high-points",
      :backlink => "http://www.church.org/sermon/1234",
      :video => @video,
      :audio => @audio,
    ))
    @audio_url_matcher = url_to_regex(@lesson.audio.url)
    @video_url_matcher = url_to_regex(@lesson.video.url)
  end

  it "renders attributes in <p>" do
    render
    assert_select '#lesson'

    rendered.should match "Road to Damascus Part 1"
    rendered.should match "God famously meets us in the low places.  This is a study on God intersecting our high-points"
    rendered.should match "http://www.church.org/sermon/1234"

    rendered.should match @audio.basename
    rendered.should match @audio_url_matcher

    rendered.should match @video.basename
    rendered.should match @video_url_matcher
  end
end
