# == Schema Information
#
# Table name: faq_answers
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  body           :text
#  more_info_path :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_faq_answers_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe FaqAnswer, :type => :model do
  subject { build(:faq_answer) }

  it "builds from factory", :internal do
    expect { create(:faq_answer) }.to_not raise_error
  end

  describe '#build_questions_for(array_of_strings)' do
    it 'creates associated Questions for each str' do
      expect {
        subject.build_questions_for(%w{foo bar baz})
        subject.save
      }.to change {subject.questions.count}.by(3)
    end

  end
end
