class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :parent,       index:true
      t.text       :type,         index:true,  null:false
      t.references :ministry,     index:true,  null:false
      t.text       :title,                     null:false
      t.text       :description
      t.hstore     :display_options
      t.attachment :poster
      
      t.datetime :expires_at
      t.timestamps null: false
    end
    
    add_foreign_key :posts, :ministries
  end
end
