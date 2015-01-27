require 'rails_helper'

describe "admin/lessons/index" do
  before(:each) do
    @audio, @video = [audio_file, video_file]
    lessons = assign(:lessons, [
      build_stubbed(:lesson,
        :title => "Road to Damascus Part 1",
        :description => "God famously meets us in the low places.  This is a study on God intersecting our high-points",
        :backlink => "http://www.church.org/sermon/1234",
        :video => @video,
        :audio => @audio,
      ),
      build_stubbed(:lesson,
        :title => "Road to Damascus Part 2",
        :description => "God famously meets us in the low places.  This is a study on God intersecting our high-points",
        :backlink => "http://www.church.org/sermon/1235",
        :video => @video,
        :audio => @audio,
      )
    ])
    base_url = 'http://media.cornerstonesf.chruch/test/media/lessons/\d+'
    @audio_url_matcher = %r`#{base_url}/audios/original/#{@audio.basename}\?*{10}`
    @video_url_matcher = %r`#{base_url}/videos/original/#{@video.basename}\?*{10}`
  end

  it "renders a list of lessons" do
    render
    assert_select('.lesson', count: 2)
    
    expect(rendered).to match "Road to Damascus Part 1"
    expect(rendered).to match "God famously meets us in the low places.  This is a study on God intersecting our high-points"
    expect(rendered).to match "http://www.church.org/sermon/1234"
    
    expect(rendered).to match @audio.basename
    expect(rendered).to match @audio_url_matcher
    
    expect(rendered).to match @video.basename
    expect(rendered).to match @video_url_matcher
  end
end
