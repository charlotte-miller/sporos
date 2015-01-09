# == Schema Information
#
# Table name: group_memberships
#
#  id              :integer          not null, primary key
#  group_id        :integer          not null
#  user_id         :integer          not null
#  is_public       :boolean          default("true")
#  role_level      :integer          default("0")
#  state           :string           default("pending"), not null
#  request_sent_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_group_memberships_on_group_id_and_user_id   (group_id,user_id) UNIQUE
#  index_group_memberships_on_state                  (state)
#  index_group_memberships_on_user_id_and_is_public  (user_id,is_public)
#

FactoryGirl.define do
  factory :group_membership do
    group
    member
    is_public true
  end
end
