class AddFeaturedAtToPost < ActiveRecord::Migration
  def change
    add_column :posts, :featured_at, :datetime
  end
end
