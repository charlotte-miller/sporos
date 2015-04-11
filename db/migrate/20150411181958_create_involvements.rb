class CreateInvolvements < ActiveRecord::Migration
  def change
    create_table :involvements do |t|
      t.references :user,     null:false
      t.references :ministry, null:false
      t.integer :status,      null:false,  default:0
      t.integer :level,       null:false,  default:0

      t.timestamps null: false
    end
    
    add_foreign_key :involvements, :users
    add_foreign_key :involvements, :ministries
    
    add_index :involvements, [:ministry_id, :level]
    add_index :involvements, [:user_id, :ministry_id]
  end
end
