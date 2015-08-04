require 'mixins/external_table'


class LegacyMedia < ActiveRecord::Base
  include ExternalTable

  belongs_to :series, :class_name => "LegacySeries"
  has_one :channel, :through => :series, :class_name => "LegacyChannel"

  def self.update_all
    legacy_media = LegacyMedia.order('date DESC').all  #.where(active:true)
    puts "### Updating Lessons from LegacyMedia"
    puts legacy_media.all.map(&:find_create_or_update_media_lesson).length
  end

  def find_create_or_update_media_lesson
    lesson = Lesson.find_by_backlink(backlink) || raise( ActiveRecord::RecordNotFound )

    lesson.study_id         = series.find_create_or_update_media_study.id
    lesson.description      = best_description
    lesson.author           = best_author
    lesson.backlink         = backlink
    lesson.video_vimeo_id   = existing_vimeo_id
    lesson.video_remote_url = video_remote_url      unless existing_vimeo_id || (lesson.video_original_url == clean_media_url)
    lesson.audio_remote_url = audio_remote_url      unless lesson.audio_original_url == clean_media_url
    lesson.handout_remote_url = handout_url         if handout_url && lesson.handout_original_url != handout_url

    lesson.save!                                    if lesson.changed?
    lesson

  rescue ActiveRecord::RecordNotFound
    attrs = {
      study_id:         series.find_create_or_update_media_study.id,
      title:            title,
      description:      best_description,
      author:           best_author,
      backlink:         backlink, }

    attrs.merge!(audio_remote_url:  audio_remote_url)   if audio_remote_url
    attrs.merge!(video_remote_url:  video_remote_url)   if video_remote_url && !existing_vimeo_id
    attrs.merge!(video_vimeo_id:    existing_vimeo_id)  if existing_vimeo_id
    attrs.merge!(handout_remote_url:handout_url)        if handout_url

    lesson = Lesson.create!(attrs)
    lesson
  end

private
  def existing_vimeo_id
    return nil if media_embed.blank?
    media_embed.match(/player.vimeo.com\/video\/(\d+)\??/)[1]
  end

  def video_remote_url
    return nil if media_url.blank? && media_embed.blank?

    if media_url.present?
      unless media_url =~ /\.mp3$/
        media_url
      end
    else
      existing_vimeo_id ? "https://vimeo.com/#{existing_vimeo_id}" : nil
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

  def clean_media_url
    clean_url_str = 3.times.inject(media_url) {|memo,i| memo = URI.unescape(memo).strip }
    URI.escape(clean_url_str)
  end

  def backlink
    "http://cornerstone-sf.org/tv/detail/#{slug}/"
  end

  def handout_url
    regx = /http\S*\.pdf/
    return nil unless description =~ regx
    description.match(regx)[0]
  end
end



