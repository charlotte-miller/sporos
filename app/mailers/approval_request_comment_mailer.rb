class ApprovalRequestCommentMailer < ApplicationMailer

  def notify_all(approval_request, comment_body)
    @approval_request = approval_request.to_obj
    @sender = @approval_request.user
    @peers  = @approval_request.peers.map(&:user).map(&:email)
    @comment_body = comment_body

    mail(from: "\"#{@sender.first_name} from Cornerstone\" <do-not-reply@cornerstonesf.org>",
         to: @peers,
         subject: "Comments on #{@approval_request.post.title}",
         cc: @sender.email)
  end
end
