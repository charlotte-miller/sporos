class CreateContentPages < ActiveRecord::Migration
  def change
    create_table :content_pages do |t|
      t.string  :slug,          null: false
      t.string  :title,         null: false
      t.text    :body,          null: false
      t.text    :seo_keywords,  null: false, array:true, default:[]

      t.timestamps              null: false
    end
    
    add_index :content_pages, :slug, unique:true
  end
end
