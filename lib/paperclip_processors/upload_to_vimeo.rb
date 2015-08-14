# Upload the attached video to Vimeo
#
module Paperclip
  class UploadToVimeo < Processor
    COMM_ARTS_BUFFER = Rails.env.production? ? 5.gigabytes : 0 # Total 20gb / week
    attr_reader :video_vimeo_id

    def initialize(file, options = {}, attachment = nil)
      super
      @lesson = attachment.instance
      @video_vimeo_id = @lesson.video_vimeo_id
    end

    def make
      return file if already_a_vimeo_video? || already_uploaded? || over_vimeo_upload_quota? || file_too_small?
      vimeo_api.upload_to_vimeo!(file, {
        title: @lesson.title,
        description: @lesson.description,
        show_url: @lesson.show_url,
      })
      attachment.instance.update_attribute :video_vimeo_id, vimeo_api.video_vimeo_id
      return file
    end

  private

    def already_a_vimeo_video?
      @lesson.video_original_url =~ /vimeo\.com/
    end

    def already_uploaded?
      @lesson.video_vimeo_id && vimeo_api.get_info.duration > 0
    end

    def file_too_small?
      file.size < 5000 #NOT media (probably a 404.html)
    end

    def over_vimeo_upload_quota?
      vimeo_api.over_vimeo_upload_quota?
    end

    def vimeo_api
      @vimeo_api ||= VimeoUploadApi.new(@video_vimeo_id)
    end
  end
end
