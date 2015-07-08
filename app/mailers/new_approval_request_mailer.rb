class NewApprovalRequestMailer < ApplicationMailer

  def request_approval(approval_request)
    @approval_request = approval_request.to_obj

    @sender = @approval_request.user
    @peers  = @approval_request.peers.map(&:user).map(&:email)
    mail(from: "\"#{@sender.first_name} from Cornerstone\" <do-not-reply@cornerstonesf.org>",
         to: @peers,
         subject: "Require approval",
         cc: @sender.email)
  end
end
