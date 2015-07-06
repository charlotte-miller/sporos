class RemovePrintAndDesignFromCommArtsRequest < ActiveRecord::Migration
  def change
    remove_column :comm_arts_requests, :print
    remove_column :comm_arts_requests, :design
  end
end
