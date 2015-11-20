class ApprovalRequestMailerPreview < ActionMailer::Preview

  def open_approval_request
    approval_request = ApprovalRequest.except_authors.first || FactoryGirl.create(:approval_request)
    ApprovalRequestMailer.open_approval_request(approval_request.to_findable_hash)
  end

  def open_approval_request_for_author
    approval_request = ApprovalRequest.only_authors.first || FactoryGirl.create(:author_approval_request)
    ApprovalRequestMailer.open_approval_request(approval_request.to_findable_hash)
  end
end
