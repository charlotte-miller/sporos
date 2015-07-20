class AddArchivedToCommArtsRequest < ActiveRecord::Migration
  def change
    add_column :comm_arts_requests, :archived_at, :datetime
    add_index :comm_arts_requests, :archived_at
  end
end
