# == Schema Information
#
# Table name: involvements
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  ministry_id :integer          not null
#  status      :integer          default("0"), not null
#  level       :integer          default("0"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_involvements_on_ministry_id_and_level    (ministry_id,level)
#  index_involvements_on_user_id_and_ministry_id  (user_id,ministry_id) UNIQUE
#

require 'rails_helper'

RSpec.describe Involvement, :type => :model do
  subject { build(:involvement) }

  it "builds from factory", :internal do
    expect { create(:involvement) }.to_not raise_error
  end
  
  it { should belong_to(:ministry) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:ministry_id) }
  # it { should validate_associated(:user) }      # not is shoulda
  # it { should validate_associated(:ministry) }  # not is shoulda
  # it { should validate_uniqueness_of(:ministry_id).scoped_to(:user_id) }
  
  describe '#level' do    
    Involvement.levels.map(&:first).each do |level|
      it "is an Enumerable w/ #{level}" do
        invol = build(:involvement, level:level)
        expect(invol.send("#{level}?")).to be true
        expect(invol.level).to eq(level.to_s)
      end
    end
  end
end
