class ApprovalRequestCommentMailerPreview < ActionMailer::Preview
  def notify_all
    ApprovalRequestCommentMailer.notify_all(ApprovalRequest.last.to_findable_hash, "Comment Body")
  end
end
