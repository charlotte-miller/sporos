# == Schema Information
#
# Table name: searchjoy_searches
#
#  id               :integer          not null, primary key
#  rails_session_id :text
#  ui_session_data  :jsonb            default("{}"), not null
#  search_type      :text
#  query            :text
#  normalized_query :text
#  results_count    :integer
#  created_at       :datetime
#  updated_at       :datetime
#  convertable_id   :integer
#  convertable_type :text
#  converted_at     :datetime
#
# Indexes
#
#  index_searchjoy_searches_on_convertable_id_and_convertable_type  (convertable_id,convertable_type)
#  index_searchjoy_searches_on_created_at                           (created_at)
#  index_searchjoy_searches_on_rails_session_id                     (rails_session_id)
#  index_searchjoy_searches_on_search_type_and_created_at           (search_type,created_at)
#  index_searchjoy_searches_on_search_type_and_normalized_query_an  (search_type,normalized_query,created_at)
#

class SearchSession < Searchjoy::Search
  before_save :map_convertable_type, :set_converted_at

  def map_convertable_type
    self.search_type = self.convertable_type = case convertable_type
    when 'sermon'   then 'Lesson'
    when 'music'    then 'Lesson'
    when 'video'    then 'Lesson'
    when 'page'     then 'Page'
    when 'question' then 'Faq'
    # when 'ministry' then 'Faq'
    # when 'event' then 'Faq'
    end
  end

  def set_converted_at
    if !converted? && convertable
      self.converted_at = Time.now
    end
  end

end
