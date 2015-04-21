# == Schema Information
#
# Table name: ministries
#
#  id          :integer          not null, primary key
#  slug        :string           not null
#  name        :string           not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_ministries_on_name  (name) UNIQUE
#  index_ministries_on_slug  (slug) UNIQUE
#

require 'rails_helper'

RSpec.describe Ministry, :type => :model do
  subject { build(:ministry) }

  it "builds from factory", :internal do
    expect { create(:ministry) }.to_not raise_error
    expect { create(:populated_ministry) }.to_not raise_error
  end
  
  it { should have_many(:posts) }
  it { should have_many(:involvements) }
  
  describe 'ASSOCIATIONS' do
    before(:all) do
      @subject = create(:populated_ministry)
    end
    
    describe '#members, :volunteers, :leaders, :editors' do
      
      it { should have_many(:members).through(:involvements) }
      it { should have_many(:volunteers).through(:involvements) }
      it { should have_many(:leaders).through(:involvements) }
      it { should have_many(:editors).through(:involvements) }
      
      it 'scopes the association by level' do
        expect(@subject.members.count).to    eq(2)
        expect(@subject.volunteers.count).to eq(2)
        expect(@subject.leaders.count).to    eq(2)
        expect(@subject.editors.count).to    eq(2)
        
        expect(@subject.members.map {|u|u.involvements.in(@subject)}.map(&:level).uniq).to    eq ["member"]
        expect(@subject.volunteers.map {|u|u.involvements.in(@subject)}.map(&:level).uniq).to eq ["volunteer"]
        expect(@subject.leaders.map {|u|u.involvements.in(@subject)}.map(&:level).uniq).to    eq ["leader"]
        expect(@subject.editors.map {|u|u.involvements.in(@subject)}.map(&:level).uniq).to    eq ["editor"]
      end
    end
    
    describe '#more_involved_than_a_members, #more_involved_than_a_volunteers, #more_involved_than_a_leaders' do
      it { should have_many(:more_involved_than_a_members).through(:involvements) }
      it { should have_many(:more_involved_than_a_volunteers).through(:involvements) }
      it { should have_many(:more_involved_than_a_leaders).through(:involvements) }
    
      it 'scopes the association by level' do
        expect(@subject.more_involved_than_a_members.count).to eq(6)
        expect(@subject.more_involved_than_a_members.map {|u|u.involvements.in(@subject)}.map(&:level).uniq).to eq ["volunteer", "leader", "editor"]
      
        expect(@subject.more_involved_than_a_volunteers.count).to eq(4)
        expect(@subject.more_involved_than_a_volunteers.map {|u|u.involvements.in(@subject)}.map(&:level).uniq).to eq ["leader", "editor"]
      
        expect(@subject.more_involved_than_a_leaders.count).to eq(2)
        expect(@subject.more_involved_than_a_leaders.map {|u|u.involvements.in(@subject)}.map(&:level).uniq).to eq ["editor"]
      end
      
    end
  end
end
