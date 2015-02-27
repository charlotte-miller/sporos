# ===Adds helpers for ElasticSearch Integration
#
module Searchable
  extend ActiveSupport::Concern
  
  included do
    searchkick({
      callbacks: :async,
      wordnet:   true
      # text_start: [:name] #autocomplete #requires this become a class method similar to :has_attachable_file
    })
    
    #https://github.com/ankane/searchkick#indexing
    define_method( :search_data ){raise NotImplementedError}
    define_method( :should_index? ){raise NotImplementedError}
    
    # scope :search_import, -> { includes(:study) }
  end
  
private

  def searchable_title str=title
    str.downcase.gsub(/^(an?|the|for|by)\b/, '').strip
  end
end