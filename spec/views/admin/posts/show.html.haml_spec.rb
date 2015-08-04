require 'rails_helper'

RSpec.describe "admin/posts/show", :type => :view do
  include PostsHelper

  before(:all) do
    @ministry = create(:populated_ministry)
    @post     = assign(:post, create(:post,
      :ministry => @ministry,
      :author => @ministry.volunteers.first,
      :title => "MyText",
      :description => "MyText",
      :poster => "",
      :url => 'http://www.thevillagechurch.net/resources/sermons/series/james/',
    ))
    def form_authenticity_token; 'adsfads' ;end
    def current_user; @post.author ;end

    @current_users_approval_request = assign(:current_users_approval_request, ApprovalRequest.find_by( user:@post.author, post:@post ))
    @approval_statuses = assign(:approval_statuses, {AUTHOR:'complete', LEADER:'complete',EDITOR:'disabled'})
    @comments = assign(:comments, [])
    @comments_data = assign(:comments_data, comments_data)
  end

  it "renders attributes" do
    view.stub(:current_user) {  @post.author }
    render
    expect(rendered).to match(%r{http://www.thevillagechurch.net/resources/sermons/series/james/})
  end

  it 'renders approval_statuses' do
    view.stub(:current_user) {  @post.author }
    render
    assert_select '.step-progress-step.complete', count:2
    assert_select '.step-progress-step.disabled', count:1
  end
end
