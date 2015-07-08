class NewApprovalRequestMailerPreview < ActionMailer::Preview
  def request_approval
    NewApprovalRequestMailer.request_approval(ApprovalRequest.last.to_findable_hash)
  end
end