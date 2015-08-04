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
  before(:all) do
    @ministry = create(:populated_ministry)
  end

  subject { build(:involvement, ministry:@ministry) }

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

  describe '.in_ministry(ministry)' do

  end

  describe '.more_involved_in_this_ministry' do
    subject { build_stubbed(:involvement, ministry:@ministry) }

    it 'returns Users' do
      expect(subject.more_involved_in_this_ministry.first).to be_a User
    end

    it 'returns MORE INVOLVED Users' do
      (0..2).each do |i|
        approvers = build_stubbed(:involvement, ministry:@ministry, level:i).more_involved_in_this_ministry
        approver_levels = approvers.map {|u| u.involvements.in_ministry(@ministry).pluck('level') }.flatten
        expect(approver_levels.min).to be > i
      end
    end
  end

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
