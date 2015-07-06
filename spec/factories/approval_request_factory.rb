# == Schema Information
#
# Table name: approval_requests
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  post_id          :integer          not null
#  status           :integer          default("0"), not null
#  last_vistited_at :datetime         not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_approval_requests_on_post_id              (post_id)
#  index_approval_requests_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#  index_approval_requests_on_user_id_and_status   (user_id,status)
#

FactoryGirl.define do
  factory :approval_request do
    post
    user
    status {ApprovalRequest.statuses.first[0].to_sym} 
  end

end
