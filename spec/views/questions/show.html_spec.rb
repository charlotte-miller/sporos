require 'rails_helper'

describe "questions/show" do
  before(:each) do
    @question = assign(:question, stub_model(Question,
      :source_id => 1,
      :source_type => 'Lesson',
      :text => "MyText",
      :answers_count => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    assert_select "#question"

    # rendered.should match(/1/)
    # rendered.should match(/2/)
    # rendered.should match(/MyText/)
    # rendered.should match(/3/)
  end
end
