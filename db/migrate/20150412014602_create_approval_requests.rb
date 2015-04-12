class CreateApprovalRequests < ActiveRecord::Migration
  def change
    create_table :approval_requests do |t|
      t.references :user, index: true
      t.references :post, index: true
      t.integer    :status,  null:false,  default:0
      t.text       :notes

      t.timestamps null: false
    end
    
    add_foreign_key :approval_requests, :users
    add_foreign_key :approval_requests, :posts
  end
end
