# inspired by https://gist.github.com/406460 and 
# http://pivotallabs.com/users/rolson/blog/articles/1249-stubbing-out-paperclip-imagemagick-in-tests
# plus some additional monkeypatching to prevent "too many files open" err's
#
# place this file in <app root>/spec/support
#

RSpec.configure do |config|
  $paperclip_stub_size = "800x800"
end

module Paperclip

  class Geometry
    def self.from_file file
      parse($paperclip_stub_size)
    end
  end

  class Thumbnail
    def make
      src_path = Rails.root.join('spec/files/', 'pixel.jpg') #user_profile_image.jpg
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode
      FileUtils.cp(src_path.to_s, dst.path)
      return dst
    end
  end

  class Attachment
    def post_process
    end
  end

  class Ffmpeg
    def identify
      {}
    end
  end

  class MediaTypeSpoofDetector
    # def type_from_file_command_with_unfake
    #   Cocaine::CommandLine.unfake!
    #   original_response = type_from_file_command_without_unfake
    #   Cocaine::CommandLine.fake!
    #   return original_response
    # end
    # alias_method_chain :type_from_file_command, :unfake
    
    def type_from_file_command
      case @file.extname
        when /jpe?g/  then 'image/jpeg'
        when '.gif'   then 'image/gif'
        when '.m4v'   then 'video/mp4'
        when '.mp3'   then 'audio/mpeg'
        when '.m4a'   then 'audio/mp4'
      end
    end
  end

  module Storage
    module Filesystem
      def flush_writes
        @queued_for_write.each{|style, file| file.close}
        @queued_for_write = {}
      end
      def flush_deletes
        @queue_for_delete = []
      end
    end
  end
end

# module Paperclip
#   def self.run cmd, params = "", expected_outcodes = 0
#     case cmd
#     when "identify"
#       return "100x100"
#     when "convert"
#       return
#     else
#       super
#     end
#   end
# end