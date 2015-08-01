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
                        :s3_host_alias => AppConfig.domains.assets,
                        :content_type => [ 'audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio' ] 
                        }.merge(common_config)

    
    has_attachable_file :video, {
                        :s3_host_alias => AppConfig.domains.assets,  #archive only - hosting through Vimeo
                        :skip_processing_urls => ['vimeo.com'],
                        :content_type => ['video/mp4'] 
                        }.merge(common_config)

    
    has_attachable_file :poster_img, {
                        # :processors      => [:thumbnail, :pngquant],
                        :default_style => :sd,
                        :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
                        :styles => {
                          sd:     { geometry: SD_SIZE,     format: 'png', convert_options: "-strip" },
                          hd:     { geometry: HD_SIZE,     format: 'png', convert_options: "-strip" },
                          mobile: { geometry: MOBILE_SIZE, format: 'png', convert_options: "-strip" }}}.merge(common_config)

  
    has_attachable_file :handout, {
                        :s3_host_alias => AppConfig.domains.assets,
                        :content_type => [ 'application/pdf' ] 
                        }.merge(common_config)

    
    process_in_background :audio
    process_in_background :video
    process_in_background :poster_img
    process_in_background :handout

  end #included


  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  
  def poster_img_w_study_backfill
    return poster_img if self.poster_img.present?
    study.poster_img
  end
  
  def retry_media_download
    missing_video = video_original_url.present? && video_vimeo_id.blank?
    missing_audio = audio_original_url.present? && audio_file_name.blank?
    
    return unless missing_audio || missing_video
    Rails.cache.delete(:over_vimeo_upload_quota)
    if missing_video
      self.video_remote_url = video_original_url
    elsif missing_audio
      self.audio_remote_url = audio_original_url
    end
    self.save!
  end
  
private

  # DEPRECATED
  # the audio_to_video processor requires :poster_img
  def process_poster_img_first
    return unless Array.wrap(@attachments_for_processing).include? :poster_img
    @attachments_for_processing.delete(:poster_img) && @attachments_for_processing.unshift(:poster_img)
  end
end