# Upload the attached video to Vimeo
#
module Paperclip
  class UploadToVimeo < Processor
    COMM_ARTS_BUFFER = Rails.env.production? ? 5.gigabytes : 0 # Total 20gb / week
    attr_reader :video_vimeo_id

    class << self
      def over_limit?
        Rails.cache.read(:over_vimeo_upload_quota)
      end

      def for_lesson(lesson)
        new(Tempfile.new(lesson.title), {}, OpenStruct.new(instance:lesson))
      end
    end

    def initialize(file, options = {}, attachment = nil)
      super
      @lesson = attachment.instance
      @video_vimeo_id = @lesson.video_vimeo_id
    end

    def make
      return file if already_a_vimeo_video? || already_uploaded? || over_vimeo_upload_quota? || file_too_small?
      upload_to_vimeo!(file)
      attachment.instance.update_attribute :video_vimeo_id, @video_vimeo_id

      return file
    end

    def get_info
      contact_vimeo :get, "https://api.vimeo.com/videos/#{@video_vimeo_id}"
    end

  private

    def already_a_vimeo_video?
      @lesson.video_original_url =~ /vimeo\.com/
    end

    def already_uploaded?
      @lesson.video_vimeo_id && get_info.duration > 0
    end

    def file_too_small?
      file.size < 5000 #NOT media (probably a 404.html)
    end

    def over_vimeo_upload_quota?
      account_info  = contact_vimeo(:get, "https://api.vimeo.com/me")
      free_space    = account_info.upload_quota.space.free
      is_over_quota = COMM_ARTS_BUFFER + file.size > free_space
      if is_over_quota
        Rails.cache.write(:over_vimeo_upload_quota, true, expires_in:1.week)
        Rails.logger.info("[[OVER WEEKLY VIMEO QUOTA]] #{free_space} remaining")
      end

      is_over_quota
    end

    def upload_to_vimeo!(video_file)
      generate_vimeo_ticket!
      @video_vimeo_id = contact_vimeo :post, @ticket.upload_link_secure, body:{ file_data:video_file }
      update_video_metadata
    end

    def update_video_metadata(overrides={})
      contact_vimeo :patch, "https://api.vimeo.com/videos/#{@video_vimeo_id}", headers: {'Content-Type' => "application/json"}, body: MultiJson.dump({
        name:         @lesson.title,
        description:  @lesson.description,
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
            link: @lesson.show_url,
          }},
          playbar:true,
          volume:true,

        },
      }.deep_merge(overrides), mode: :compat)
      # source: https://developer.vimeo.com/api/endpoints/videos#PATCH/videos/%7Bvideo_id%7D
    end

# super private

    def generate_vimeo_ticket!
      @ticket = if @video_vimeo_id
        contact_vimeo :put, "https://api.vimeo.com/videos/#{@video_vimeo_id}/files", body:{
          type:'POST',  upgrade_to_1080:false, #requires pro account
          redirect_url:'http://cornerstone-sf.org'}
      else
        contact_vimeo :post, 'https://api.vimeo.com/me/videos', body:{
          type:'POST',  upgrade_to_1080:false, #requires pro account
          redirect_url:'http://cornerstone-sf.org'}
      end
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
