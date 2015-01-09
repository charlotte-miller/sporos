# == Schema Information
#
# Table name: groups
#
#  id               :integer          not null, primary key
#  state            :string(50)       not null
#  name             :string           not null
#  description      :text             not null
#  is_public        :boolean          default("true")
#  meets_every_days :integer          default("7")
#  meetings_count   :integer          default("0")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_groups_on_state_and_is_public  (state,is_public)
#

FactoryGirl.define do
  factory :group do  
    state 'is_open'
    name        { Faker::Lorem.sentence(rand(3..8))  }
    description { Faker::Lorem.paragraph(rand(2..5)) }
    meets_every_days { rand(1..7) }
    is_public true
  end
  
  factory :group_w_member, parent: :group do
    ignore do
      new_member {FactoryGirl.create(:member)}
    end
    group_memberships { [FactoryGirl.create(:group_membership, member:new_member)] }
  end
  
  factory :group_w_member_and_meeting, :parent => :group_w_member do
    ignore do
      new_meeting {FactoryGirl.create(:meeting)}
    end
    meetings { [new_meeting] } 
  end
end
