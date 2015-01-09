# == Schema Information
#
# Table name: answers
#
#  id            :integer          not null, primary key
#  question_id   :integer
#  author_id     :integer
#  text          :text
#  blocked_count :integer          default("0")
#  stared_count  :integer          default("0")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_answers_on_author_id    (author_id)
#  index_answers_on_question_id  (question_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    question
    author
    text {Faker::Lorem.paragraph(rand(2..5))}
    blocked_count 1
    stared_count 1
  end
end
