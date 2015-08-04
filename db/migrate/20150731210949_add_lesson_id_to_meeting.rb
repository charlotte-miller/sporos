class AddLessonIdToMeeting < ActiveRecord::Migration
  def change
    add_reference :meetings, :lesson, index: true
    add_foreign_key :meetings, :lessons
  end
end
