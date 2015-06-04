# == Schema Information
#
# Table name: uploaded_files
#
#  id                 :integer          not null, primary key
#  from_id            :integer
#  from_type          :text
#  session_id         :text
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  video_file_name    :string
#  video_content_type :string
#  video_file_size    :integer
#  video_updated_at   :datetime
#
# Indexes
#
#  index_uploaded_files_on_from_id_and_from_type  (from_id,from_type)
#  index_uploaded_files_on_session_id             (session_id)
#

class UploadedFile < ActiveRecord::Base
  include AttachableFile
  
  delegate :url_helpers, to: 'Rails.application.routes'
  
  belongs_to :from, polymorphic:true
  
  attr_protected #none
  has_attachable_file :image,
                      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
                      :processors => [:thumbnail, :paperclip_optimizer],
                      paperclip_optimizer: { jhead:true, jpegrecompress:true, jpegtran:true },
                      :styles => {
                        xlarge:       { geometry: "1500x1500>", format: 'jpg', convert_options: "-strip" },
                        large:        { geometry: "800x800>",   format: 'jpg', convert_options: "-strip" },
                        medium:       { geometry: "500x500>",   format: 'jpg', convert_options: "-strip" },
                        small:        { geometry: "200x200>",   format: 'jpg', convert_options: "-strip" },
                        large_thumb:  { geometry: "120x120#",   format: 'jpg', convert_options: "-strip" },
                        thumb:        { geometry: "100x100#",   format: 'jpg', convert_options: "-strip" }
                      }
  
  has_attachable_file :video,
                      :content_type => ["video/mp4", "video/quicktime", "video/x-msvideo", "video/3gpp"],
                      :processors => [:upload_to_vimeo] # :set_image_to_video_poster #https://vimeo.com/api/v2/video/6271487.json

  process_in_background :image
  process_in_background :video
  
  validates_presence_of :file
  
  def file
    [image, video].find(&:present?)
  end
  
  def file_as_json
    raise ArgumentError unless file.present?
    { name: file.basename,
      size: file.size,
      url:  file.url(:large),
      thumbnail_url: file.url(:small),
      delete_url:  url_helpers.admin_uploaded_file_url(self),
      delete_type: 'DELETE',
      is_video: file.name == :video }
  end
end
