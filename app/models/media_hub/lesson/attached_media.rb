# === Configuration for processing & storing a Lesson's audio/video files. 
# - Uses the AttachableFile module
# - Uses paperclip-ffmpeg for transcoding
#
module Lesson::AttachedMedia
  extend  ActiveSupport::Concern
  include AttachableFile
  included do
    
    # Video Dimensions
    SD_SIZE     = '640x360#'
    HD_SIZE     = '1280x720#'
    MOBILE_SIZE = '480x270#'
    
    Paperclip.interpolates(:study_id) { |attachment, style| attachment.instance.study_id }
    common_config = {
      production_path: 'studies/lesson_media/:study_id/:hash:quiet_style.:extension' }

    has_attachable_file :audio, {
                        :s3_host_alias => AppConfig.domains.assets_origin,
                        :content_type => ['audio/mp4', 'audio/mpeg'] }.merge(common_config)

    
    has_attachable_file :video, {
                        :s3_host_alias => AppConfig.domains.assets_origin,  #archive only - hosting through Vimeo
                        :processors => [:upload_to_vimeo],
                        :skip_processing_urls => ['youtube.com', 'vimeo.com'],
                        :content_type => ['video/mp4'] }.merge(common_config)

    
    has_attachable_file :poster_img, {
                        # :processors      => [:thumbnail, :pngquant],
                        :default_style => :sd,
                        :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
                        :styles => {
                          sd:     { geometry: SD_SIZE,     format: 'png', convert_options: "-strip" },
                          hd:     { geometry: HD_SIZE,     format: 'png', convert_options: "-strip" },
                          mobile: { geometry: MOBILE_SIZE, format: 'png', convert_options: "-strip" }}}.merge(common_config)

  
    process_in_background :audio
    process_in_background :video
    process_in_background :poster_img

  end #included


  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  
  def poster_img_w_study_backfill
    return poster_img if self.poster_img.present?
    study.poster_img
  end
  
private

  # DEPRECATED
  # the audio_to_video processor requires :poster_img
  def process_poster_img_first
    return unless Array.wrap(@attachments_for_processing).include? :poster_img
    @attachments_for_processing.delete(:poster_img) && @attachments_for_processing.unshift(:poster_img)
  end
end