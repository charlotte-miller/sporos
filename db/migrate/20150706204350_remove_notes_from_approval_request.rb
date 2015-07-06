class RemoveNotesFromApprovalRequest < ActiveRecord::Migration
  def change
    remove_column :approval_requests, :notes
  end
end
