FactoryGirl.define do
  factory :user_lesson_state do
    user
    lesson
    media_progress { Faker::Number.between(1, lesson.duration) }
  end
end
