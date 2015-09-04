# == Schema Information
#
# Table name: faqs
#
#  id                :integer          not null, primary key
#  question_variants :text             default("{}"), is an Array
#  answer            :text             not null
#  more_info_path    :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :faq do
    question_variants ['When is church', 'When do services start']
    answer "Mission Campus: Saturday at 7pm, Sunday at 9am, 10:30am, and 12pm"
    more_info_path '/times-and-locations'
  end

end
