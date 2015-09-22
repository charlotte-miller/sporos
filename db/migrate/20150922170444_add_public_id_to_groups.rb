class AddPublicIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :public_id, :string, limit: 20
    add_index :groups, :public_id
  end
end
