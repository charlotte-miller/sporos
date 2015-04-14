class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :parent
      t.text       :type,         index:true,  null:false
      t.references :ministry,     index:true,  null:false
      t.references :user,         index:true,  null:false
      t.text       :title,                     null:false
      t.text       :description
      t.hstore     :display_options
      t.attachment :poster
      
      t.datetime :published_at
      t.datetime :expired_at
      t.timestamps            null: false
    end
    
    add_foreign_key :posts, :ministries
    add_foreign_key :posts, :users
    
    add_index :posts, :parent_id, where:'parent_id IS NOT NULL'
  end
end
