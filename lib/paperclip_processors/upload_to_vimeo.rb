# Upload the attached video to Vimeo
#
module Paperclip
  class UploadToVimeo < Processor
    
    def initialize(file, options = {}, attachment = nil)
      super
      @origin_url = attachment.instance.video_remote_url
    end
    
    def make
      return file if already_a_vimeo_video? || over_vimeo_upload_quota?

      generate_vimeo_ticket
      
      
      return file
    end
    
  private
    def already_a_vimeo_video?
      @origin_url =~ /vimeo\.com/
    end
      
    def over_vimeo_upload_quota?
      account_info = contact_vimeo(:get, "https://api.vimeo.com/me")
      free_space = account_info['upload_quota']['space']['free']
      file.size > free_space
    end
    
    def generate_vimeo_ticket
      @ticket ||= contact_vimeo :post, 'https://api.vimeo.com/me/videos', params:{upgrade_to_1080:true}
    end
    
    
    def contact_vimeo(method, url, options={})      
      request = Typhoeus::Request.new(url, {
        method: method,
        accept_encoding: "gzip",
        headers: {"Authorization" => "bearer #{AppConfig.vimeo.token}"}
      }.deep_merge(options))
      Oj.load(request.run.body)
    end
  end
end