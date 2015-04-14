class CreateMinistries < ActiveRecord::Migration
  def change
    create_table :ministries do |t|
      t.string  :name,        null:false
      t.text    :description
      t.string  :url_path,    null:false

      t.timestamps null: false
    end
    
    add_index :ministries, :name,     unique:true
    add_index :ministries, :url_path, unique:true
  end
end
