class ApprovalRequestMailerPreview < ActionMailer::Preview
  def open_approval_request
    ApprovalRequestMailer.open_approval_request(ApprovalRequest.last.to_findable_hash)
  end
end
