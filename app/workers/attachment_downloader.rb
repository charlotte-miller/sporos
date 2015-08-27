require 'tempfile'
require 'uri'
require Rails.root.join('lib/paperclip_processors/upload_to_vimeo')

class AttachmentDownloader
  extend Resque::Plugins::Retry #https://github.com/lantins/resque-retry
  @queue = :downloader

  class << self
    def perform_async(*args)
      Resque.enqueue(AttachmentDownloader, *args)
    end

    def perform(*args)
      new.perform(*args)
    end
  end

  def perform(obj_hash, attachment_names=[])
    @obj_instance = obj_hash.to_obj
    Array.wrap(attachment_names).each {|attachment| download_and_assign attachment }
    @obj_instance.save!
  end

private

  # Paperclip assignment will trigger any Paperclip::Processor
  # Skips original_urls matching the Paperclip options[:skip_processing_urls]
  def download_and_assign( attachment_name )
    url_str   = @obj_instance.send("#{attachment_name}_original_url")
    file_name = File.basename( URI(url_str).path )
    extention = File.extname(URI(url_str).path )

    if attachment_name.to_sym == :video
      # Paperclip options[:skip_processing_urls]
      return if @obj_instance.send(attachment_name).trusted_third_party? || VimeoUploadApi.new.over_vimeo_upload_quota?
    end

    begin
      tempfile = Tempfile.new([file_name, extention])
      tempfile.binmode
      curl_to(url_str, tempfile.path)
      @obj_instance.send("#{attachment_name}=", tempfile)

      # Use the downloaded video file
      upload_to_vimeo(tempfile) if attachment_name.to_s == 'video'

    ensure
      # Kill all the tempfiles!
      # tempfile.truncate(0)
      tempfile.close
      # tempfile.unlink
    end
  end

  # Uses system `curl` to avoid buffering content into ruby
  # This can be updated when Curb/Typhoeus supports the --output option
  def curl_to(from_url, to_file_path)
    curl = Cocaine::CommandLine.new('curl', ":from_url -o :to_file_path -L --silent")
    curl.run(from_url:from_url, to_file_path:to_file_path)
  end

  def upload_to_vimeo(tempfile)
    Paperclip::UploadToVimeo.new(tempfile, {}, @obj_instance.video).make
  end
end
