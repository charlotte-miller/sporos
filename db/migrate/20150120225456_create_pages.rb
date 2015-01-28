class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :parent_id
      t.string  :slug,          null: false
      t.string  :title,         null: false
      t.text    :body,          null: false
      t.text    :seo_keywords,  null: false,  array:true,  default:[]
      t.boolean :hidden_link,   null: false,               default:false

      t.timestamps              null: false
    end
    
    add_index :pages, :slug, unique:true
  end
end
