# == Schema Information
#
# Table name: meetings
#
#  id         :integer          not null, primary key
#  group_id   :integer          not null
#  lesson_id  :integer          not null
#  position   :integer          default("0"), not null
#  state      :string(50)       not null
#  date_of    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_meetings_on_group_id_and_position  (group_id,position)
#  index_meetings_on_group_id_and_state     (group_id,state)
#  index_meetings_on_lesson_id              (lesson_id)
#

FactoryGirl.define do
  factory :meeting, aliases: [:current_meeting] do
    ignore do
      position nil
    end
    
    group
    lesson
    state   'current'
    date_of { Time.now + 1.week }
  end
end
