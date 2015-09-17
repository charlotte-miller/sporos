# https://github.com/thoughtbot/paperclip/blob/master/lib/paperclip/interpolations.rb
# Paperclip.interpolates(:timestamp_now) { |attachment, style| Time.now.to_i }
Paperclip.interpolates(:quiet_style) { |attachment, style| ((string_style = style.to_s) == 'original' ? '' : "-#{string_style}") }

Paperclip::Attachment.default_options[:use_timestamp] = false

