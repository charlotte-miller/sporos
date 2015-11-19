class ApprovalRequestMailer < ApplicationMailer
  include ApplicationHelper
  include PostsHelper

  def open_approval_request(approval_request)
    @approval_request = approval_request.to_obj
    set_template_data

    if @approval_request.is_author?
      mail(from: "\"CornerstoneSF\" <do-not-reply@cornerstonesf.org>",
           to: @receiver.email,
           subject: "Thank You For Posting: #{@post.title}",
           template_name:'open_approval_request_for_author')
    else
      mail(from: "\"#{@sender.first_name} from Cornerstone\" <do-not-reply@cornerstonesf.org>",
           to: @receiver.email,
           subject: "#{@ministry.name} wants to post #{indefinitize(post_type_of(@post))}".titleize)
    end
  end

  def close_approval_request(approval_request)
    @approval_request = approval_request.to_obj
    set_template_data

    # same subject for threading
    if @approval_request.is_author?
      mail(from: "\"CornerstoneSF\" <do-not-reply@cornerstonesf.org>",
           to: @receiver.email,
           subject: "Thank You For Posting: #{@post.title}")
    else
      mail(from: "\"#{@sender.first_name} from Cornerstone\" <do-not-reply@cornerstonesf.org>",
           to: @receiver.email,
           subject: "#{@ministry.name} wants to post #{indefinitize(post_type_of(@post))}".titleize)
    end
  end

private

  def set_template_data
    raise RuntimeError.new('@approval_request required') unless @approval_request
    @ministry = @approval_request.ministry
    @post     = @approval_request.post
    @sender   = @approval_request.author
    @receiver = @approval_request.user
  end
end
