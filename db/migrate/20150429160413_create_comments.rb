class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments, :force => true do |t|
      t.integer  :commentable_id
      t.string   :commentable_type
      t.string   :title
      t.text     :body
      t.integer  :user_id,   null: false, index: true
      t.integer  :parent_id, null: true,  index: true
      t.integer  :lft,       null: false, index: true
      t.integer  :rgt,       null: false, index: true

      t.integer :depth,          :null => false, :default => 0, index:true
      t.integer :children_count, :null => false, :default => 0
      t.timestamps
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end

  def self.down
    drop_table :comments
  end
end
