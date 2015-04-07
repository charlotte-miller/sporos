require 'typhoeus'
require "#{Rails.root}/lib/extensions/native/deep_struct"

namespace :cloudfront do
  desc "Get the current Cloudfront IP ranges for whitelist"
  task :ip_list do
    response = Typhoeus.get('https://ip-ranges.amazonaws.com/ip-ranges.json', followlocation: true)
    body = DeepStruct.from_json(response.body)
    cloudfront_ip_ranges = body.prefixes.map do |aws_ip_range|
      next unless aws_ip_range['service'] == 'CLOUDFRONT'
      aws_ip_range['ip_prefix']
    end.compact
    pbcopy cloudfront_ip_ranges.join(', ')
    puts 'Ready to Paste'
  end
end

def pbcopy(input)
  str = input.to_s
  IO.popen('pbcopy', 'w') { |f| f << str }
  str
end

def pbpaste
  `pbpaste`
end