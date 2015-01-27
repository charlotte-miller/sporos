require 'mixins/external_table'


class LegacyMedia < ActiveRecord::Base
  include ExternalTable
  
  def self.update_all
    all.map(&:find_create_or_update_media_lesson).length
  end
  
  def find_create_or_update_media_lesson
    
  end
end


class LegacySeries < ActiveRecord::Base
  include ExternalTable
  
  belongs_to :channel, :class_name => "LegacyChannel"
  
  def self.update_all
    all.map(&:find_create_or_update_media_study).length
  end
  
  def find_create_or_update_media_study
    study = Media::Study.friendly.find(slug)
    study.title                 = title
    study.description           = best_description
    study.poster_img_remote_url = image_url
    study.channel_id            = channel.find_create_or_update_media_channel.id
    study.save!                 if study.changed?
    study
    
  rescue ActiveRecord::RecordNotFound
    study = Media::Channel.create!({
      title:                  title,
      description:            best_description,
      poster_img_remote_url:  image_url,
      channel_id:             channel.find_create_or_update_media_channel.id
    })
    study.update_attribute(:slug, slug) if study.slug != slug #force at create
    study
  end
  
  def best_description
    return nil if description.blank? && sub_title.blank?
    description.blank? ? sub_title : description
  end
  
  def image_url
    "http://media.cornerstone-sf.org/#{image}"
  end
end


class LegacyChannel < ActiveRecord::Base
  include ExternalTable
  
  def self.update_all
    all.map(&:find_create_or_update_media_channel).length
  end
  
  def find_create_or_update_media_channel
    channel = Media::Channel.friendly.find(slug)
    channel.title     = title
    channel.position  = order
    channel.save!     if channel.changed?
    channel
    
  rescue ActiveRecord::RecordNotFound
    channel = Media::Channel.create!({
      position: order,
      title:    title,
    })
    channel.update_attribute(:slug, slug) if channel.slug != slug #force at create
    channel
  end
end