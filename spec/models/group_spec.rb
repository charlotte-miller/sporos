# == Schema Information
#
# Table name: groups
#
#  id               :integer          not null, primary key
#  state            :string(50)       not null
#  name             :string(255)      not null
#  description      :text(65535)      not null
#  is_public        :boolean          default("1")
#  meets_every_days :integer          default("7")
#  meetings_count   :integer          default("0")
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_groups_on_state_and_is_public  (state,is_public)
#

require 'rails_helper'

describe Group do
  it { should have_one(  :current_meeting )}
  it { should have_many( :meetings )}
  it { should have_many( :group_memberships )}
  it { should have_many( :members ).through( :group_memberships ) } #users
  it { should have_many( :questions ) } 
  # it { should delegate_method(:meetings=).to(:group_memberships) }
  it "builds from factory", :internal do
    lambda { create(:group) }.should_not raise_error
    lambda { create(:group_w_member) }.should_not raise_error
  end
  
  describe 'a public group' do    
    it ".publicly_searchable scope filters by public " do
      sql = Group.publicly_searchable.to_sql
      sql.should match(/`is_public` = 1/)
      sql.should match(/`state` = 'is_open'/)
    end
  end
  
  describe '[state machine]' do
    describe 'scopes -' do
      Group.aasm.states.map(&:to_s).each do |state|
        it "matches on '#{state}'" do
          expect(Group.send(state).to_sql).to match( /`state` = '#{state}'/ )
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
