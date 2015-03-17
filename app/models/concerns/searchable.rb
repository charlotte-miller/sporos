# ===Adds helpers for ElasticSearch Integration
#
module Searchable
  extend ActiveSupport::Concern
  
  REQUIRED_KEYS = [:title, :display_description, :path, :description, :keywords]
  
  included do
    include Sanitizable
    include ActionView::Helpers::TextHelper #truncate, excerpt, hightlight, etc.
    include Elasticsearch::Model
    delegate :url_helpers, to: 'Rails.application.routes'

    # include Elasticsearch::Model::Callbacks  # https://github.com/elasticsearch/elasticsearch-rails/tree/master/elasticsearch-model#asynchronous-callbacks
  end

  module ClassMethods

    def searchable_model( options={}, &specific_indexes )
      options = DeepStruct.new(options)

      class_eval do
        index_name     AppConfig.elasticsearch.index_name
        document_type  options.type || name.downcase 
        
        settings index: { number_of_shards: 1 } do
          mappings dynamic: 'false' do
            # dynamic:'false' - Indexes are not automaticly created and must be added by code to be searched
            # - this makes adding new indexes easier as you cannot update existing indexes (potetnally triggered by new fields)
            # [options] http://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-core-types.html
                        
            indexes :title, 
                     analyzer: 'english',
                     index_options: 'offsets',
                     boost: 2.0
                     # stem_exclusion: dont_stem
         
            indexes :description, 
                     analyzer: 'english', 
                     index_options: 'offsets'
                     # boost: 1.5
                     # stem_exclusion: dont_stem
                            
            indexes :keywords, 
                     analyzer: 'keyword', #:not_analyzed
                     boost:2.0
                     #might makes sense to stem bible verses
                            
            # Not Searchable
            indexes :path,                index:'no'
            indexes :display_description, index:'no'

            # Add model specific indexes
            instance_eval( &specific_indexes ) if block_given?
          end
        end
      end
    end

  end #ClassMethods
  
  
private
  
  # Helpers - could be analyzers  
  def shorter_plain_text(str, truncate_options={})
    truncate( plain_text(str), {
      length:30, 
      omission:'...', 
      separator: ' '
    }.merge(truncate_options))
  end
  
  # def dont_stem(*terms)
  #   (BOOKS_OF_THE_BIBLE | terms).map(&:downcase).uniq
  # end
end