require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the GroupsHelper. For example:
#
# describe GroupsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe GroupsHelper do
  before(:all) do
    @study_group     = create(:study_group)
    @past_meeting    = create(:meeting, date_of: Time.now - 5.minute,  group: @study_group)
    @current_meeting = create(:meeting, date_of: Time.now + 5.minute,  group: @study_group)
    @future_meeting  = create(:meeting, date_of: Time.now + 15.minute, group: @study_group)
  end

  let(:study_group) { @study_group }
  let(:past_meeting) { @past_meeting }
  let(:current_meeting) { @current_meeting }
  let(:future_meeting) { @future_meeting }

  describe '#current_meeting' do
    it { expect(current_meeting_from(study_group)).to eq(current_meeting) }
  end

  describe '#current_meeting_position' do
    it { expect(current_meeting_position(past_meeting, current_meeting)).to eq("past") }
    it { expect(current_meeting_position(current_meeting, current_meeting)).to eq("current") }
    it { expect(current_meeting_position(future_meeting, current_meeting)).to eq("future") }

    describe 'all meeting has finished' do
      let(:current_meeting) { nil }
      it { expect(current_meeting_position(future_meeting, current_meeting)).to eq("finished") }
    end
  end

  describe '#percent_completed' do
    let(:user_lesson_state) { FactoryGirl.build(:user_lesson_state, media_progress: 100) }
    let(:lesson) { FactoryGirl.build(:lesson, duration: 200) }
    let(:lesson_no_duration) { FactoryGirl.build(:lesson, duration: nil) }

    it { expect(percent_completed(user_lesson_state, lesson)).to eq(50) }
    it { expect(percent_completed(user_lesson_state, lesson_no_duration)).to eq(0.0) }
  end
end
