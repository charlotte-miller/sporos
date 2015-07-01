class CreateCommArtsRequests < ActiveRecord::Migration
  def change
    create_table :comm_arts_requests do |t|
      t.references :post, index: true
      t.boolean :print
      t.boolean :design
      t.boolean :design_requested
      t.jsonb   :design_creative_brief, null:false, default:'{}'
      t.boolean :print_postcard
      t.boolean :print_poster
      t.boolean :print_booklet
      t.boolean :print_badges

      t.timestamps null: false
    end
    add_foreign_key :comm_arts_requests, :posts
  end
end
