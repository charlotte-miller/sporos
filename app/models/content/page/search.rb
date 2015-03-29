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
    searchable_model # [title, display_description, description, keywords, path] are already declaired
    
    scope :search_indexable, lambda { where(hidden_link:false) }
  end
  
  def as_indexed_json(options={})
    {
      title:                title,
      display_description:  shorter_plain_text(body),
      path:                 legacy_url, #url_helpers.page_url(self),
      description:          plain_text(body),
      keywords:             seo_keywords,
    }
  end
end