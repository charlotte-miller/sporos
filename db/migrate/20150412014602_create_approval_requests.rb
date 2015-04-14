class CreateApprovalRequests < ActiveRecord::Migration
  def change
    create_table :approval_requests do |t|
      t.references :user,    null:false
      t.references :post,    null:false
      t.integer    :status,  null:false,  default:0
      t.text       :notes

      t.timestamps null: false
    end
    
    add_foreign_key :approval_requests, :users
    add_foreign_key :approval_requests, :posts
    
    add_index :approval_requests, [:user_id, :post_id], unique:true
    add_index :approval_requests, [:user_id, :status]
    add_index :approval_requests, :post_id
  end
end
