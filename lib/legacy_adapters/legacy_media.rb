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
    # lesson.audio_remote_url = audio_remote_url  unless lesson.audio_original_url == audio_remote_url
    lesson.save!                                if lesson.changed?
    lesson
    
  rescue ActiveRecord::RecordNotFound
    lesson = Lesson.create!({
      study_id:         series.find_create_or_update_media_study.id,
      title:            title,
      description:      best_description,
      author:           best_author,
      #audio_remote_url: audio_remote_url,
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
      vimeo_id = media_embed.match(/src="\/\/player.vimeo.com\/video\/(\d+)\?/)[1] rescue binding.pry
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



