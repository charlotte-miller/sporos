# Upload the attached video to Vimeo
#
module Paperclip
  class UploadToVimeo < Processor
    COMM_ARTS_BUFFER = Rails.env.production? ? 5.gigabytes : 0 # Total 20gb / week
    attr_reader :vimeo_video_id
    
    def initialize(file, options = {}, attachment = nil)
      super
      @lesson = attachment.instance
    end
    
    def make
      return file if already_a_vimeo_video? || already_uploaded? || over_vimeo_upload_quota? || file_too_small?
      upload_to_vimeo!(file)
      attachment.instance.update_attribute :video_vimeo_id, @vimeo_video_id
      
      return file
    end
  
  protected
  
    def already_a_vimeo_video?
      @lesson.video_original_url =~ /vimeo\.com/
    end
    
    def already_uploaded?
      !!@lesson.video_vimeo_id
    end
    
    def file_too_small?
      file.size < 5000 #NOT media (probably a 404.html)
    end

    def over_vimeo_upload_quota?
      account_info  = contact_vimeo(:get, "https://api.vimeo.com/me")
      free_space    = account_info.upload_quota.space.free
      is_over_quota = COMM_ARTS_BUFFER + file.size > free_space
      Rails.logger.info("[[OVER WEEKLY VIMEO QUOTA]] #{free_space} remaining") if is_over_quota
      return is_over_quota
    end
    
  private
      
    def upload_to_vimeo!(video_file)
      generate_vimeo_ticket!
      @vimeo_video_id = contact_vimeo :post, @ticket.upload_link_secure, body:{ file_data:video_file }
      contact_vimeo :patch, "https://api.vimeo.com/videos/#{@vimeo_video_id}", body:{
        name:         @lesson.title,
        description:  @lesson.description,
        license:      'by-nc-nd',
        review_link:  false,
        # embed:{ },
        privacy:{
          view: 'anybody',
          embed: 'public', }
      }
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
        headers: {"Authorization" => "bearer #{AppConfig.vimeo.token}"}
      }.deep_merge(options))
      
      if (response_obj = request.run).code == 302
        unless (redirect_to = response_obj.headers["Location"]) =~ /^http:\/\/cornerstone-sf\.org/
          contact_vimeo :get, redirect_to
        else
          CGI.parse( URI.parse(redirect_to).query )["video_uri"][0].gsub(/^\/videos\//,'')
        end
      else
        DeepStruct.from_json(response_obj.body)
      end
    end
  end
end