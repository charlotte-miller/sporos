# == Schema Information
#
# Table name: uploaded_files
#
#  id                :integer          not null, primary key
#  from_id           :integer
#  from_type         :text
#  session_id        :text
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_uploaded_files_on_from_id_and_from_type  (from_id,from_type)
#  index_uploaded_files_on_session_id             (session_id)
#

class UploadedFile < ActiveRecord::Base
  include AttachableFile
  
  belongs_to :from, polymorphic:true
  
  attr_protected #none
  has_attachable_file :file,
                      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
                      :processors => [:thumbnail, :paperclip_optimizer],
                      paperclip_optimizer: { pngquant: true },
                      :styles => { 
                        original: { geometry: "4000x4000>", format: 'png', convert_options: "-strip" },
                        large:    { geometry: "1500x1500>", format: 'png', convert_options: "-strip" },
                        medium:   { geometry: "300x300>",   format: 'png', convert_options: "-strip" },
                        small:    { geometry: "200x200>",   format: 'png', convert_options: "-strip" },
                        thumb:    { geometry: "100x100",    format: 'png', convert_options: "-strip" }
                      }

  process_in_background :file
end
