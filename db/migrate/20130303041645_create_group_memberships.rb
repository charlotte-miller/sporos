class CreateGroupMemberships < ActiveRecord::Migration
  def change
    create_table :group_memberships do |t|
      t.integer :group_id,    null:false
      t.integer :user_id,     null:false
      t.boolean :is_public,                 default: true
      t.integer :role_level,                default: 0
      t.string  :state,       null:false,   default:'pending'
      t.datetime :request_sent_at

      t.timestamps  null: false
    end
    
     add_index :group_memberships, [  :user_id, :is_public ]
     add_index :group_memberships, [  :group_id,  :user_id   ], unique:true
     add_index :group_memberships, :state
  end
end
