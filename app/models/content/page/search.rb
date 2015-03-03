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
      # indexes :title, analyzer: 'english', index_options: 'offsets'
    end
    
    # def should_index?
    #   !hidden_link
    # end

    def as_indexed_json(options={})
      {
        title: searchable_title,
        body:  plain_text(body),
        seo_keywords: seo_keywords,
        path: legacy_url, #url_helpers.page_url(self) ,
      }
    end
  end
end