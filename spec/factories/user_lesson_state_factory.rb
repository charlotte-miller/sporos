# == Schema Information
#
# Table name: user_lesson_states
#
#  id              :integer          not null, primary key
#  started_at      :datetime
#  last_visited_at :datetime
#  complete_at     :datetime
#  media_progress  :integer
#  user_id         :integer
#  lesson_id       :integer
#
# Indexes
#
#  index_user_lesson_states_on_lesson_id  (lesson_id)
#  index_user_lesson_states_on_user_id    (user_id)
#

FactoryGirl.define do
  factory :user_lesson_state do
    user
    lesson
    media_progress { Faker::Number.between(1, lesson.duration) }
  end
end
