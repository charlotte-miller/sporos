class AddImageAndVideoToUploadedFile < ActiveRecord::Migration
  def change
    rename_column :uploaded_files, :file_file_name,     :image_file_name
    rename_column :uploaded_files, :file_content_type,  :image_content_type
    rename_column :uploaded_files, :file_file_size,     :image_file_size
    rename_column :uploaded_files, :file_updated_at,    :image_updated_at
    add_column    :uploaded_files, :video_file_name,    :string
    add_column    :uploaded_files, :video_content_type, :string
    add_column    :uploaded_files, :video_file_size,    :integer
    add_column    :uploaded_files, :video_updated_at,   :datetime
  end
end
