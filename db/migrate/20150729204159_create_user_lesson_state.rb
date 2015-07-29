class CreateUserLessonState < ActiveRecord::Migration
  def change
    create_table :user_lesson_states do |t|
      t.datetime :started_at
      t.datetime :last_visited_at
      t.datetime :complete_at
      t.integer :media_progress
      t.references :user, index: true
      t.references :lesson, index: true
    end
    add_foreign_key :user_lesson_states, :users
    add_foreign_key :user_lesson_states, :lessons
  end
end
