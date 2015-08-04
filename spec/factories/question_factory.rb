# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  user_id       :integer          not null
#  admin_user_id :integer
#  source_id     :integer          not null
#  source_type   :string           not null
#  text          :text
#  answers_count :integer          default("0")
#  blocked_count :integer          default("0")
#  stared_count  :integer          default("0")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_questions_on_source_id_and_source_type       (source_id,source_type)
#  index_questions_on_stared_count_and_answers_count  (stared_count,answers_count)
#  index_questions_on_user_id                         (user_id)
#

FactoryGirl.define do
  factory :question do
    before(:create, :stub) { AWS.stub! if Rails.env.test? }

    permanent_approver
    author
    source { FactoryGirl.create(:lesson) }
    text   { Faker::Lorem.sentence(rand(3..6)) }
    # answers_count 0
  end

  factory :library_question, parent: 'question' do
    source { FactoryGirl.create(:lesson) }
  end

  factory :group_question, parent: 'question' do
    source { FactoryGirl.create(:group) }
  end
end
