# == Schema Information
#
# Table name: approval_requests
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  post_id    :integer          not null
#  status     :integer          default("0"), not null
#  notes      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_approval_requests_on_post_id              (post_id)
#  index_approval_requests_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#  index_approval_requests_on_user_id_and_status   (user_id,status)
#

class ApprovalRequest < ActiveRecord::Base
  enum status: [ :pending, :accepted, :rejected, :archived ].freeze
  
  belongs_to :user
  belongs_to :post
  
  scope :current, -> { where('status < 3') }
  scope :decided, -> { where('status = 1 OR status = 2') }
  
  after_update -> { post.update_status! }
  
  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------  
  validates_presence_of :user_id, :post_id
  validates_associated :user, :post, :on => :create
  validates_uniqueness_of :post_id, scope:[:user_id]
  
end
