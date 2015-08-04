# == Schema Information
#
# Table name: lessons
#
#  id                      :integer          not null, primary key
#  study_id                :integer          not null
#  position                :integer          default("0")
#  title                   :string           not null
#  description             :text
#  author                  :string
#  backlink                :string
#  poster_img_file_name    :string
#  poster_img_content_type :string
#  poster_img_file_size    :integer
#  poster_img_updated_at   :datetime
#  poster_img_original_url :string
#  poster_img_fingerprint  :string
#  poster_img_processing   :boolean
#  video_file_name         :string
#  video_content_type      :string
#  video_file_size         :integer
#  video_updated_at        :datetime
#  video_vimeo_id          :string
#  video_original_url      :string
#  video_fingerprint       :string
#  video_processing        :boolean
#  audio_file_name         :string
#  audio_content_type      :string
#  audio_file_size         :integer
#  audio_updated_at        :datetime
#  audio_original_url      :string
#  audio_fingerprint       :string
#  audio_processing        :boolean
#  machine_sorted          :boolean          default("false")
#  duration                :integer
#  published_at            :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_lessons_on_backlink               (backlink)
#  index_lessons_on_study_id_and_position  (study_id,position)
#  index_lessons_on_video_vimeo_id         (video_vimeo_id) UNIQUE
#

module Lesson::Search
  extend  ActiveSupport::Concern
  include Searchable

  included do
    searchable_model do
      # [title, display_description, description, keywords, path] are already declaired

      indexes :study_title,
               analyzer: 'english',      # boost:1.5
               index_options: 'offsets',
               fields:{
                 # raw:{
                 #   type:'string',
                 #   index:'not_analyzed'
                 # },
               }

      indexes :author,      analyzer: 'stop'
      indexes :duration,    type:'long'
    end

    scope :search_indexable, ->{} #-> { where('published_at IS NOT NULL') }
  end

  module ClassMethods

    def custom_import
      channel_to_type = {
        sermon: 'messages',
        music:  'music',
        # drama:  'dramavideo',              # not in UI
        video:  ['studies', 'resources', 'coffeetalk', 'mens-retreat', 'dramavideo'],
      }

      channel_to_type.each do |type, channel_name|
        channel_ids = Channel.where(slug:channel_name).pluck(:id)
        study_ids = Study.where(channel_id:channel_ids).pluck(:id)

        import({
          # scoped to search_indexable by searchable.rb
          query: ->{ where(study_id:study_ids) } ,
          type: type,
        })
      end
    end
  end

  def as_indexed_json(options={})
    {
      title:                title,
      display_description:  shorter_plain_text(description),
      path:                 url_helpers.study_lesson_path(study, self),
      study_title:          study.title,
      description:          plain_text(description),
      keywords:             study.keywords,
      author:               author,
      duration:             duration,
    }
  end
end
