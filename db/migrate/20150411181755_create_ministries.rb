class CreateMinistries < ActiveRecord::Migration
  def change
    create_table :ministries do |t|
      t.string  :slug,        null:false
      t.string  :name,        null:false
      t.text    :description

      t.timestamps null: false
    end

    add_index :ministries, :name, unique:true
    add_index :ministries, :slug, unique:true
  end
end
