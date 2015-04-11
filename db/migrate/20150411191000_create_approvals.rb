class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals do |t|
      t.references :post
      t.references :user
      t.string  :approver_ids, array: true, default: []
      t.integer :status,       null:false,  default:0
      
      t.datetime :published_at
      t.timestamps null: false
    end
    
    add_foreign_key :approvals, :posts
    add_foreign_key :approvals, :users
    
    add_index :approvals, [:post_id, :status]
    add_index :approvals, [:user_id, :status]
  end
end
