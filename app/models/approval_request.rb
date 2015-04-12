# == Schema Information
#
# Table name: approval_requests
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  post_id    :integer
#  status     :integer          default("0"), not null
#  notes      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_approval_requests_on_post_id  (post_id)
#  index_approval_requests_on_user_id  (user_id)
#

class ApprovalRequest < ActiveRecord::Base
  enum status: [ :pending, :accepted, :rejected, :archived ].freeze
  
  belongs_to :user
  belongs_to :post
  
  scope :decided, -> (obj){ where('status = 1 OR status = 2') }
  
  after_update -> { post.update_status! }
end
