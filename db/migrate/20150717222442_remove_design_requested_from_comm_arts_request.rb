class RemoveDesignRequestedFromCommArtsRequest < ActiveRecord::Migration
  def change
    remove_column :comm_arts_requests, :design_requested
  end
end
