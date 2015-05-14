class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.integer :from_id
      t.text    :from_type
      t.text    :session_id, index:true
      t.attachment :file

      t.timestamps null: false
    end
    
    add_index :uploaded_files, [:from_id, :from_type]
  end
end
