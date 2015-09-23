# == Schema Information
#
# Table name: faqs
#
#  id            :integer          not null, primary key
#  faq_answer_id :integer
#  body          :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_faqs_on_faq_answer_id  (faq_answer_id)
#

FactoryGirl.define do
  factory :faq do
    answer
    body { Faker::Lorem.sentence(rand(3..6)) }
  end

end
