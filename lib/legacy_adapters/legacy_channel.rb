require 'mixins/external_table'

class LegacyChannel < ActiveRecord::Base
  include ExternalTable

  def self.update_all
    legacy_channels = LegacyChannel.order('"order" ASC').all

    puts "### Updating Channels from LegacyChannel"
    puts legacy_channels.map(&:find_create_or_update_media_channel).length
  end

  def find_create_or_update_media_channel
    adjusted_order = order+1
    channel = Channel.friendly.find(slug)
    channel.title = title
    channel.save! if channel.changed?
    channel.insert_at(adjusted_order) unless adjusted_order == channel.position
    channel

  rescue ActiveRecord::RecordNotFound
    channel = Channel.create!({ title:title })
    channel.update_attribute(:slug, slug) if channel.slug != slug #force at create
    channel.insert_at(adjusted_order) unless adjusted_order == channel.position
    channel
  end
end