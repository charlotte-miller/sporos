require 'rails_helper'

describe "studies/index" do
  before(:each) do
    assign(:studies, [
      build_stubbed(:study,
        :title => "Road to Damascus",
        :description => "God famously meets us in the low places.  This is a study on God intersecting our high-points",
        lessons: [build_stubbed(:lesson)]
      ),
      build_stubbed(:study,
        :title => "Road to Damascus",
        :description => "God famously meets us in the low places.  This is a study on God intersecting our high-points",
        lessons: [build_stubbed(:lesson)]
      )
    ])
  end

  it "renders a list of studies" do
    render
    assert_select ".study", :count => 2

    rendered.should match "Road to Damascus"
    rendered.should match "God famously meets us in the low places.  This is a study on God intersecting our high-points"
  end
end
