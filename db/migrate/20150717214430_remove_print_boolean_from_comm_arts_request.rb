class RemovePrintBooleanFromCommArtsRequest < ActiveRecord::Migration
  def change
    remove_column :comm_arts_requests, :print_postcard
    remove_column :comm_arts_requests, :print_poster
    remove_column :comm_arts_requests, :print_booklet
    remove_column :comm_arts_requests, :print_badges
  end
end
