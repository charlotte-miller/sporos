class NewApprovalRequestMailer < ApplicationMailer
  include ApplicationHelper
  include PostsHelper

  def request_approval(approval_request)
    @approval_request = approval_request.to_obj
    @ministry = @approval_request.ministry
    @post     = @approval_request.post
    @sender   = @approval_request.author
    @receiver   = @approval_request.user

    mail(from: "\"#{@sender.first_name} from Cornerstone\" <do-not-reply@cornerstonesf.org>",
         to: @receiver.email,
         subject: "#{@ministry.name} wants to post #{indefinitize(post_type_of(@post))}".titleize)
  end
end
