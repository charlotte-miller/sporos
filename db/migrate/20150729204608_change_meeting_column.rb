class ChangeMeetingColumn < ActiveRecord::Migration
  def change
    remove_column :meetings, :state
    remove_column :meetings, :lesson_id
  end
end
