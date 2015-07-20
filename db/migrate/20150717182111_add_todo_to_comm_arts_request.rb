class AddTodoToCommArtsRequest < ActiveRecord::Migration
  def change
    add_column :comm_arts_requests, :todo, :jsonb
  end
end
