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
      
      indexes :study_title, analyzer: 'english', index_options: 'offsets', boost:1.5
      indexes :author,      analyzer: 'standard', stopwords:%w{ pastor }
      indexes :duration,    type:'long'
    end
    
    # def should_index?; !!published_at ;end
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