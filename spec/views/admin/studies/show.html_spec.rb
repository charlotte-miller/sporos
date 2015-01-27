require 'rails_helper'

describe "admin/studies/show" do
  before(:each) do
    @study = assign(:study, build_stubbed(:study,
      :slug => "road-to-damascus",
      :title => "Road to Damascus",
      :description => "God famously meets us in the low places.  This is a study on God intersecting our high-points",
      :ref_link => "http://www.church.org/podcast/1234"
    ))
  end

  it "renders attributes in <p>" do
    render
    assert_select "#study"
        
    rendered.should match "road-to-damascus"
    rendered.should match "Road to Damascus"
    rendered.should match "God famously meets us in the low places.  This is a study on God intersecting our high-points"
    rendered.should match "http://www.church.org/podcast/1234"
    # rendered.should match(/Lessons/)
  end
end
