class NewApprovalRequestMailer < ApplicationMailer
  include ApplicationHelper
  include PostsHelper

  def request_approval(approval_request)
    @approval_request = approval_request.to_obj
    @ministry = @approval_request.ministry
    @post = @approval_request.post
    @sender = @approval_request.user
    @peers  = @approval_request.peers.map(&:user).map(&:email)
    mail(from: "\"#{@sender.first_name} from Cornerstone\" <do-not-reply@cornerstonesf.org>",
         to: @peers,
         subject: "#{@ministry.name} wants to post #{indefinitize(post_type_of(@post))}".titleize,
         cc: @sender.email)
  end
end
