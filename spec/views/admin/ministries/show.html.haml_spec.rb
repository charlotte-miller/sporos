require 'rails_helper'

RSpec.describe "admin/ministries/show", :type => :view do
  before(:each) do
    @ministry = assign(:ministry, build_stubbed(:ministry,
      :name => "Name",
      :description => "MyText",
    ))
    # @grouped_users = assign(:grouped_users, )
    grouped_involvements = @ministry.involvements.group_by(&:level)
    @grouped_users = grouped_involvements.each_pair do |level, involvements|
      grouped_involvements[level] = User.find(involvements.map(&:user_id))
    end
    assign :grouped_users, @grouped_users
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end