# == Schema Information
#
# Table name: studies
#
#  id                      :integer          not null, primary key
#  slug                    :string           not null
#  channel_id              :integer          not null
#  podcast_id              :integer
#  position                :integer          not null
#  title                   :string           not null
#  description             :text
#  keywords                :text             default("{}"), is an Array
#  ref_link                :string
#  poster_img_file_name    :string
#  poster_img_content_type :string
#  poster_img_file_size    :integer
#  poster_img_updated_at   :datetime
#  poster_img_original_url :string
#  poster_img_fingerprint  :string
#  poster_img_processing   :boolean
#  lessons_count           :integer          default("0")
#  last_published_at       :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_studies_on_last_published_at                 (last_published_at)
#  index_studies_on_podcast_id_and_last_published_at  (podcast_id,last_published_at)
#  index_studies_on_slug                              (slug) UNIQUE
#

module Study::Search
  extend  ActiveSupport::Concern
  include Searchable
    
  included do
    searchable_model do
      # [title, display_description, description, keywords, path] are already declaired
      indexes :last_published_at, type: 'date'
    end
    
    scope :search_indexable, ->{} #-> { where('last_published_at IS NOT NULL') }
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
        
        import({
          # scoped to search_indexable by searchable.rb
          query: ->{ where(channel_id:channel_ids) } ,
          type: type,
        })
      end
    end
  end
  
  def as_indexed_json(options={})
    {
      title:                title,
      display_description:  shorter_plain_text(description),
      path:                 url_helpers.study_path(self),
      description:          plain_text(description),
      keywords:             keywords,
      last_published_at:    last_published_at,
    }
  end
end