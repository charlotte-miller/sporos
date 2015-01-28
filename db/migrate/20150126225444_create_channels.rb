class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.integer :position,  null:false
      t.string :title,      null:false
      t.string :slug,       null:false

      t.timestamps          null: false
    end
    
    add_index :channels, :position, unique:true
    add_index :channels, :slug,     unique:true
  end
end
