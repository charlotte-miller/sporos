# ===Adds helpers for ElasticSearch Integration
#
module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    delegate :url_helpers, to: 'Rails.application.routes'

    # include Elasticsearch::Model::Callbacks  # https://github.com/elasticsearch/elasticsearch-rails/tree/master/elasticsearch-model#asynchronous-callbacks
  end

  module ClassMethods

    def searchable_model( options={} )
      options = DeepStruct.new(options)

      class_eval do
        index_name     "sporos_#{Rails.env}"
        document_type  options.type || name.downcase 
        
        settings index: { number_of_shards: 1 } do
          mappings dynamic: 'false' do
            indexes :title, analyzer: 'english', index_options: 'offsets'
            yield
          end
        end
      end
    end

  end #ClassMethods
  
  
private
  
  # should be an analyzer
  def searchable_title str=title
    str.downcase.gsub(/^(an?|the|for|by)\b/, '').strip
  end
end