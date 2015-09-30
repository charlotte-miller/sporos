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

FactoryGirl.define do
  factory :faq_answer do
    author
    body {Faker::Lorem.paragraph(rand(2..5))}
    more_info_path '/times-and-locations'
  end
end
