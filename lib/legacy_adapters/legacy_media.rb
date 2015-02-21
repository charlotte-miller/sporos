require 'mixins/external_table'


class LegacyMedia < ActiveRecord::Base
  include ExternalTable
  
  belongs_to :series, :class_name => "LegacySeries"
  has_one :channel, :through => :series, :class_name => "LegacyChannel"
  
  def self.update_all
    legacy_media = LegacyMedia.order('date ASC').all  #.where(active:true)
    puts "### Updating Lessons from LegacyMedia"
    puts legacy_media.all.map(&:find_create_or_update_media_lesson).length
  end
  
  def find_create_or_update_media_lesson    
    lesson = Lesson.find_by_title(title) || raise( ActiveRecord::RecordNotFound )
    lesson.study_id         = series.find_create_or_update_media_study.id
    lesson.description      = best_description
    lesson.author           = best_author
    lesson.video_remote_url = video_remote_url  unless lesson.video_original_url == video_remote_url
    lesson.audio_remote_url = audio_remote_url  unless lesson.audio_original_url == audio_remote_url
    lesson.save!                                if lesson.changed?
    lesson
    
  rescue ActiveRecord::RecordNotFound
    lesson = Lesson.create!({
      study_id:         series.find_create_or_update_media_study.id,
      title:            title,
      description:      best_description,
      author:           best_author,
      audio_remote_url: audio_remote_url,
      video_remote_url: video_remote_url,
    })
    lesson
  end
  
private
  def video_remote_url
    return nil if media_url.blank? && media_embed.blank?
    
    if media_url.present?
      unless media_url =~ /\.mp3$/
        media_url
      end
    else
      vimeo_id = media_embed.match(/src="\/\/player.vimeo.com\/video\/(\d+)\?/)[1]
      "https://vimeo.com/#{vimeo_id}"
    end
  end
  
  def audio_remote_url
    media_url if media_url.present? && media_url =~ /\.mp3$/
  end
  
  def best_description
    return nil if description.blank? && sub_title.blank?
    description.blank? ? sub_title : description
  end
  
  def best_author
    presenter.blank? ? 'Cornerstone Church' : presenter
  end
  
  def image_url
    return nil if image.blank?
    "http://media.cornerstone-sf.org/#{image}"
  end
end


class LegacySeries < ActiveRecord::Base
  include ExternalTable
  
  belongs_to :channel, :class_name => "LegacyChannel"
  
  def self.update_all
    legacy_series = LegacySeries.order('"order" ASC').where(active:true)
    puts "### Updating Studies from LegacySeries"
    puts legacy_series.map(&:find_create_or_update_media_study).length
  end
  
  def find_create_or_update_media_study    
    adjusted_order = order+1
    
    study = Study.friendly.find(slug)
    study.title                 = title
    study.description           = best_description
    study.poster_img_remote_url = image_url
    study.channel_id            = channel.find_create_or_update_media_channel.id
    study.save!                 if study.changed?
    study.insert_at(adjusted_order) unless adjusted_order == study.position
    study
    
  rescue ActiveRecord::RecordNotFound
    study = Study.create!({
      title:                  title,
      description:            best_description,
      poster_img_remote_url:  image_url,
      channel_id:             channel.find_create_or_update_media_channel.id
    })
    study.update_attribute(:slug, slug) if study.slug != slug #force at create
    study.insert_at(adjusted_order) unless adjusted_order == study.position
    study
  end
  
private
  def best_description
    return nil if description.blank? && sub_title.blank?
    description.blank? ? sub_title : description
  end
  
  def image_url
    return nil if image.blank?
    "http://media.cornerstone-sf.org/#{image}"
  end
end


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