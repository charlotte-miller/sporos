# == Schema Information
#
# Table name: groups
#
#  id                      :integer          not null, primary key
#  state                   :string(50)       not null
#  name                    :string           not null
#  description             :text             not null
#  is_public               :boolean          default("true")
#  meets_every_days        :integer          default("7")
#  meetings_count          :integer          default("0")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  type                    :text             not null
#  study_id                :integer
#  approved_at             :datetime
#  poster_img_file_name    :string
#  poster_img_content_type :string
#  poster_img_file_size    :integer
#  poster_img_updated_at   :datetime
#  poster_img_fingerprint  :string
#  poster_img_processing   :boolean
#  study_group_data        :jsonb            default("{}"), not null
#  book_group_data         :jsonb            default("{}"), not null
#  affinity_group_data     :jsonb            default("{}"), not null
#  public_id               :string(20)
#
# Indexes
#
#  index_groups_on_public_id            (public_id)
#  index_groups_on_state_and_is_public  (state,is_public)
#  index_groups_on_study_id             (study_id)
#  index_groups_on_type_and_id          (type,id)
#

FactoryGirl.define do
  factory :generic_group, class: 'Group' do
    state 'is_open'
    name        { Faker::Lorem.sentence(rand(3..8))  }
    description { Faker::Lorem.paragraph(rand(2..5)) }
    meets_every_days { rand(1..7) }
    is_public true
    poster_img  { fixture_file_upload(Rails.root.join('spec/files/', 'poster_image.jpg'), 'image/jpg', true) }
  end

  factory :study_group, parent: :generic_group, class: 'Groups::StudyGroup', aliases: [:group] do
    type 'Groups::StudyGroup'
    association :study, factory: [:study_w_lessons]
  end

  factory :book_group, parent: :generic_group, class: 'Groups::BookGroup' do
    type 'Groups::BookGroup'
  end

  factory :affinity_group, parent: :generic_group, class: 'Groups::AffinityGroup' do
    type 'Groups::AffinityGroup'
  end

  factory :group_w_member, parent: :study_group do
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
