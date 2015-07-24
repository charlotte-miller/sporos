# == Schema Information
#
# Table name: groups
#
#  id                        :integer          not null, primary key
#  state                     :string(50)       not null
#  name                      :string           not null
#  description               :text             not null
#  is_public                 :boolean          default("true")
#  meets_every_days          :integer          default("7")
#  meetings_count            :integer          default("0")
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  type                      :text             not null
#  study_id                  :integer
#  approved_at               :datetime
#  poster_image_file_name    :string
#  poster_image_content_type :string
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  poster_image_fingerprint  :string
#  poster_image_processing   :boolean
#  study_group_data          :jsonb            default("{}"), not null
#  book_group_data           :jsonb            default("{}"), not null
#  affinity_group_data       :jsonb            default("{}"), not null
#
# Indexes
#
#  index_groups_on_state_and_is_public  (state,is_public)
#  index_groups_on_study_id             (study_id)
#  index_groups_on_type_and_id          (type,id)
#

require 'rails_helper'

describe Group do
  it { should have_one(  :current_meeting )}
  it { should have_many( :meetings )}
  it { should have_many( :group_memberships )}
  it { should have_many( :members ).through( :group_memberships ) } #users
  it { should have_many( :questions ) }
  # it { should delegate_method(:meetings=).to(:group_memberships) }

  [:group, :study_group, :book_group, :affinity_group, :group_w_member, :group_w_member_and_meeting].each do |factory|
    it "builds from factory #{factory}", :internal do
      expect { create(factory) }.to_not raise_error
    end
  end

  describe 'a public group' do
    it ".publicly_searchable scope filters by public " do
      sql = Group.publicly_searchable.to_sql
      sql.should match(/.?is_public.? = 't'/)
      sql.should match(/.?state.? = 'is_open'/)
    end
  end

  describe '[state machine]' do
    describe 'scopes -' do
      Group.aasm.states.map(&:to_s).each do |state|
        it "matches on '#{state}'" do
          expect(Group.send(state).to_sql).to match( /.?state.? = '#{state}'/ )
        end
      end
    end

    describe 'inflectors -' do
      Group.aasm.states.map(&:to_s).each do |state|
        it "matches on '#{state}?'" do
          group = build(:group, state: state)
          expect(group.send("#{state}?")).to be true
        end
      end
    end
  end


end
