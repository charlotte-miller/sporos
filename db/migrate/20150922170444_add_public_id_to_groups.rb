class AddPublicIdToGroups < ActiveRecord::Migration
  class Group < ActiveRecord::Base
    include Uuidable
    has_public_id :public_id, prefix:'GRP', length:20
  end

  def change
    add_column :groups, :public_id, :string, limit: 20
    add_index :groups, :public_id

    if column_exists? :groups, :public_id
      Group.where('public_id is null').find_in_batches do |groups|
        groups.each do |group|
          group.generate_missing_public_id
          group.save!
        end
      end
    end
  end
end
