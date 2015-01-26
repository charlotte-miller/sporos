class CreateMediaChannels < ActiveRecord::Migration
  def change
    create_table :media_channels do |t|
      t.integer :position,  null:false
      t.string :title,      null:false
      t.string :slug,       null:false

      t.timestamps          null: false
    end
    
    add_index :media_channels, :position, unique:true
    add_index :media_channels, :slug,     unique:true
  end
end
