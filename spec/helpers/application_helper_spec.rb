require 'rails_helper'

describe ApplicationHelper do
  let(:study_group) { FactoryGirl.create(:study_group) }
  let!(:past_meeting) { FactoryGirl.create(:meeting, date_of: Time.now - 5.minute, group: study_group) }
  let!(:current_meeting) { FactoryGirl.create(:meeting, date_of: Time.now + 5.minute, group: study_group) }
  let!(:future_meeting) { FactoryGirl.create(:meeting, date_of: Time.now + 15.minute, group: study_group) }

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
