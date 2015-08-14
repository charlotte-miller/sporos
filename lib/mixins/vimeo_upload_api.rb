class VimeoUploadApi
  attr_accessor :vimeo_video_id
  delegate :upload_link_secure, :complete_uri, :ticket_id, :uri, to: :generate_vimeo_ticket!

  def initialize(ticket_id=false)
    @vimeo_video_id = ticket_id
  end

  # ACCOUNT INFO
  def get_info
    contact_vimeo :get, "https://api.vimeo.com/videos/#{@video_vimeo_id}"
  end

  def over_vimeo_upload_quota?(from_cache=false)
    return Rails.cache.read(:over_vimeo_upload_quota) if from_cache

    account_info  = contact_vimeo(:get, "https://api.vimeo.com/me")
    free_space    = account_info.upload_quota.space.free
    is_over_quota = COMM_ARTS_BUFFER + file.size > free_space
    if is_over_quota
      Rails.cache.write(:over_vimeo_upload_quota, true, expires_in:1.week)
      Rails.logger.info("[[OVER WEEKLY VIMEO QUOTA]] #{free_space} remaining")
    end
    return is_over_quota
  end

  # POST API
  def upload_to_vimeo!(video_file, meta_data)
    ticket = generate_vimeo_ticket!
    @vimeo_video_id = contact_vimeo :post, ticket.upload_link_secure, body:{ file_data:video_file }
    update_video_metadata!(meta_data)
  end

  # STREAMING API
  def complete_upload(vimeo_options={})
    # verify_once     = contact_vimeo :put,    "https://api.vimeo.com/upload?ticket_id=#{vimeo_options[:ticket_id]}", headers:{'Content-Length'=> 0, 'Content-Range' => 'bytes */*'}
    info = contact_vimeo :get, "https://api.vimeo.com#{vimeo_options[:uri]}"
    completion_result = contact_vimeo :delete, "https://api.vimeo.com#{vimeo_options[:complete_uri]}"
    location = completion_result.headers["Location"]
    {location: location, vimeo_id:location.gsub(/\D/,'') }
  end

  # VIDEO METADATA
  def update_video_metadata!(meta_data)
    contact_vimeo :patch, "https://api.vimeo.com/videos/#{@vimeo_video_id}", headers: {'Content-Type' => "application/json"}, body: MultiJson.dump({
      name:         meta_data[:title],
      description:  meta_data[:description],
      license:      'by-nc-nd',
      review_link:  false,
      privacy:{
        view: 'disable', #(Rails.env.production? ? 'disable' : 'anybody'),
        embed: 'public',
        add: false,
        comments:'nobody',
        download:false,
      },
      embed:{
        buttons:{
          like:false,
          share:false,
          embed:false,
          watchlater:false,
          scaling:false,

          hd:true,
          fullscreen:true,
        },
        logos:{custom:{
          active:false,
          sticky:false,
          link: meta_data[:show_url],
        }},
        playbar:true,
        volume:true,

      },
    }.deep_merge(overrides), mode: :compat)
    # source: https://developer.vimeo.com/api/endpoints/videos#PATCH/videos/%7Bvideo_id%7D
  end

private

  def generate_vimeo_ticket!
    @ticket ||=(
      if @video_vimeo_id
        contact_vimeo :put, "https://api.vimeo.com/videos/#{@video_vimeo_id}/files", body:{
          type:'POST',  upgrade_to_1080:false, #requires pro account
          redirect_url:'http://cornerstone-sf.org'}
      else
        contact_vimeo :post, 'https://api.vimeo.com/me/videos', body:{
          type:'POST',  upgrade_to_1080:false, #requires pro account
          redirect_url:'http://cornerstone-sf.org'}
      end
    )
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
