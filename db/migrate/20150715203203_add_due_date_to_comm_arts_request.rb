class AddDueDateToCommArtsRequest < ActiveRecord::Migration
  def change
    add_column :comm_arts_requests, :due_date, :datetime
  end
end
