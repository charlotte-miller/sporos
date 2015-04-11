# == Schema Information
#
# Table name: approvals
#
#  id           :integer          not null, primary key
#  post_id      :integer
#  user_id      :integer
#  approver_ids :string           default("{}"), is an Array
#  status       :integer          default("0"), not null
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_approvals_on_post_id_and_status  (post_id,status)
#  index_approvals_on_user_id_and_status  (user_id,status)
#

FactoryGirl.define do
  factory :approval do
    post
    user
    status {Approval.statuses.first[0].to_sym} 
  end

end
