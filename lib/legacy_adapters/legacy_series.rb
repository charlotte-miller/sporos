require 'mixins/external_table'

class LegacySeries < ActiveRecord::Base
  include ExternalTable

  belongs_to :channel, :class_name => "LegacyChannel"

  def self.update_all
    legacy_series = LegacySeries.order('"order" DESC').where(active:true)
    puts "### Updating Studies from LegacySeries"
    puts legacy_series.map(&:find_create_or_update_media_study).length
  end

  def find_create_or_update_media_study
    adjusted_order = order+1

    study = Study.friendly.find(slug)
    study.title                 = title
    study.description           = best_description
    study.poster_img_remote_url = image_url  unless study.poster_img_original_url == image_url
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
