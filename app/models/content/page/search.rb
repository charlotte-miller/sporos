# == Schema Information
#
# Table name: pages
#
#  id           :integer          not null, primary key
#  parent_id    :integer
#  slug         :string           not null
#  title        :string           not null
#  body         :text             not null
#  seo_keywords :text             default("{}"), not null, is an Array
#  hidden_link  :boolean          default("false"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pages_on_slug  (slug) UNIQUE
#

module Page::Search
  extend  ActiveSupport::Concern
  include Searchable
    
  included do
    searchable_model do
      # [title, short_description, path] are already declaired
      
      indexes :body,         analyzer: 'english', index_options: 'offsets'
      indexes :seo_keywords, analyzer: 'keyword', boost:2.0
    end
    
    # def should_index?
    #   !hidden_link
    # end

    def as_indexed_json(options={})
      {
        title:              searchable_title,
        short_description:  shorter_plain_text(body),
        body:               plain_text(body),
        seo_keywords:       seo_keywords,
        path:               legacy_url, #url_helpers.page_url(self) ,
      }
    end
  end
end