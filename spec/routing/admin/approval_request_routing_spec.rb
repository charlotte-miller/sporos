require "rails_helper"

RSpec.describe Admin::ApprovalRequestsController, :type => :routing do
  it 'routes to #update_status_from_link' do
    expect(get: "/admin/approval_requests/1/update_status_from_link").to route_to("admin/approval_requests#update_status_from_link", id: "1")
  end

  it 'routes to #index' do
    expect(get: "/admin/editable_posts").to route_to("admin/approval_requests#editable_posts")
  end
end
