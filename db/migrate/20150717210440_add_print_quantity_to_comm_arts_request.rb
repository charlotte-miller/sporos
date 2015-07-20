class AddPrintQuantityToCommArtsRequest < ActiveRecord::Migration
  def change
    add_column :comm_arts_requests, :print_quantity, :jsonb
  end
end
