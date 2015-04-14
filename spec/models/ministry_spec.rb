# == Schema Information
#
# Table name: ministries
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  url_path    :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_ministries_on_name      (name) UNIQUE
#  index_ministries_on_url_path  (url_path) UNIQUE
#

require 'rails_helper'

RSpec.describe Ministry, :type => :model do
  subject { build(:ministry) }

  it "builds from factory", :internal do
    expect { create(:ministry) }.to_not raise_error
  end
  
  it { should have_many(:posts) }
  it { should have_many(:involvements) }
  
  describe 'involvement.level' do
    before(:all) do
      @subject = create(:ministry)
      Involvement.levels.map do |level|
        create(:involvement, ministry: @subject, level: level[1])
      end
    end
    
    it { should have_many(:members).through(:involvements) }
    it { should have_many(:volunteers).through(:involvements) }
    it { should have_many(:leaders).through(:involvements) }
    it { should have_many(:staff).through(:involvements) }
    it { should have_many(:admins).through(:involvements) }
    
    it 'restricts access by level' do
      binding.pry
      expect(@subject.members.count).to eq(5)
      
      expect(@subject.volunteers.count).to eq(4)
      expect(@subject.volunteers.first.ministry_involvements.map(&:status).uniq[0]).to be :volunteer
      
      expect(@subject.leaders.count).to eq(3)
      expect(@subject.leaders.first.ministry_involvements.first.leader?).to be true
      
      expect(@subject.staff.count).to eq(2)
      expect(@subject.staff.first.ministry_involvements.first.staff?).to be true
      
      expect(@subject.admins.count).to eq(1)
      expect(@subject.admins.first.ministry_involvements.first.admin?).to be true
    end
  end
end
