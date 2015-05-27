class VimeoCreateTicket
  attr_accessor :ticket
  delegate :upload_link_secure, :complete_uri, :ticket_id, :uri, to: :ticket
  
  def initialize(skip_ticket=false)
    skip_ticket || generate_vimeo_ticket!
  end
  
  # def over_vimeo_upload_quota?
  #   account_info = contact_vimeo(:get, "https://api.vimeo.com/me")
  #   free_space = account_info.upload_quota.space.free
  #   file.size > free_space
  # end
  
    
  # POST API
  def upload_to_vimeo!(video_file)
    # generate_vimeo_ticket!
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
  
  # Streaming API
  def complete_upload(vimeo_options={})    
    # verify_once     = contact_vimeo :put,    "https://api.vimeo.com/upload?ticket_id=#{vimeo_options[:ticket_id]}", headers:{'Content-Length'=> 0, 'Content-Range' => 'bytes */*'}
    info = contact_vimeo :get, "https://api.vimeo.com#{vimeo_options[:uri]}"
    completion_result = contact_vimeo :delete, "https://api.vimeo.com#{vimeo_options[:complete_uri]}"
    location = completion_result.headers["Location"]
    {location: location, vimeo_id:location.gsub(/\D/,'') }
  end
  
private
  
  def generate_vimeo_ticket!
    @ticket = contact_vimeo :post, 'https://api.vimeo.com/me/videos', body:{
      type:'streaming'}  # upgrade_to_1080:true, #pro account
      # redirect_url:'http://cornerstone-sf.org'}
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
      if response_obj.body.present?
        DeepStruct.from_json(response_obj.body)
      else
        response_obj
      end
    end
  end
  
end