# Upload the attached video to Vimeo
#
module Paperclip
  class UploadToVimeo < Processor
    
    def initialize(file, options = {}, attachment = nil)
      super
      @origin_url = attachment.try('instance').try('video_remote_url')
    end
    
    def make
      return file if already_a_vimeo_video? || over_vimeo_upload_quota?
      upload_to_vimeo!(file)
      attachment.instance.update_attribute :video_remote_url, "https://vimeo.com/#{@vimeo_video_id}"
      
      return file
    end
  
  protected
  
    def already_a_vimeo_video?
      @origin_url =~ /vimeo\.com/
    end
    
    def over_vimeo_upload_quota?
      account_info = contact_vimeo(:get, "https://api.vimeo.com/me")
      free_space = account_info.upload_quota.space.free
      file.size > free_space
    end
    
  private
      
    def upload_to_vimeo!(video_file)
      generate_vimeo_ticket!
      successful_redirect = contact_vimeo :post, @ticket.upload_link_secure, body:{ file_data:video_file}
      video_endpoint_id = CGI.parse( URI.parse(successful_redirect.effective_url).query )["video_uri"][0]
      @vimeo_video_id = video_endpoint_id.gsub(/^\/videos\//,'')
    end
    
    def generate_vimeo_ticket!
      @ticket = contact_vimeo :post, 'https://api.vimeo.com/me/videos', body:{
        type:'POST',  # upgrade_to_1080:true, #pro account
        redirect_url:'http://cornerstone-sf.org'}
    end
    
    def contact_vimeo(method, url, options={})      
      request = Typhoeus::Request.new(url, {
        method: method,
        accept_encoding: "gzip",
        followlocation: true,
        headers: {"Authorization" => "bearer #{AppConfig.vimeo.token}"}
      }.deep_merge(options))
      response = request.run
      if response.redirect_count >= 2
        response
      else
        DeepStruct.new Oj.load(response.body)
      end
    end
  end
end