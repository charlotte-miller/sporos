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
        
        settings index: { 
          number_of_shards: 1,
          number_of_replicas: 0,
          analysis: {
            # char_filter: { ... custom character filters ... },
            # tokenizer:   { ...    custom tokenizers     ... },
            filter: {
              bi_gram:{
                type:'shingle',
                output_unigrams:false,
              },
              
              tri_gram:{
                type:'shingle',
                min_shingle_size:3,
                max_shingle_size:3,
                output_unigrams:false,
              },
              
              wordnet_synonym:{
                type:'synonym',
                format:'wordnet',
                synonyms_path:'/var/lib/wn_s.pl'
              },

              cstone_synonyms:{
                type:'synonym',
                synonyms:[
                  'sermon => message',
                  'christ => jesus',
                ]
              },
              
              cstone_stopwords:{
                type:'stop',
                stopwords:['pastor']
              },
              
              max_50:{
                type:'length',
                max:50
              },
              
              common_leading_stopword:{
                type:'pattern_replace',
                pattern:"^(an?|the)\b",
                replacement:'',
                preserve_original:true
              }
            },
            
            analyzer: {
              html_stem: {
                type:'custom',
                char_filter: ['html_strip'],
                tokenizer: 'classic',
                filter:['trim', 'lowercase', 'asciifolding', 'stop', 'cstone_synonyms', 'cstone_stopwords', 'porter_stem'], #'wordnet_synonym', 'kstem'
              },
              
              html_bi_gram:{
                type:'custom',
                char_filter: ['html_strip'],
                tokenizer: 'classic',
                filter:['trim', 'lowercase', 'asciifolding', 'common_leading_stopword', 'cstone_synonyms', 'max_50', 'bi_gram'], #'wordnet_synonym',
              },

              html_tri_gram:{
                type:'custom',
                char_filter: ['html_strip'],
                tokenizer: 'classic',
                filter:['trim', 'lowercase', 'asciifolding', 'common_leading_stopword', 'cstone_synonyms', 'max_50', 'tri_gram'], #'wordnet_synonym',
              },
            },
          }        
        } do
          mappings dynamic: 'false' do
            #Indexes are not automaticly created and must be added by code to be searched

            indexes :title,
                     analyzer: 'html_stem',          #boost: 1.5
                     fields:{
                       bi_grams:{
                         type:'string',
                         analyzer:'html_bi_gram'     #boost: 2.0
                       },
                       tri_grams:{
                         type:'string',
                         analyzer:'html_tri_gram'    #boost: 3.0
                       },
                       # raw:{
                       #   type:'string',
                       #   index:'not_analyzed'
                       # },
                     }
                                     
            indexes :description, 
                     analyzer: 'html_stem',
                     fields:{
                       bi_grams:{                    # boost: 1.0
                         type:'string',
                         analyzer:'html_bi_gram'
                       }
                       # raw:{
                       #   type:'string',
                       #   index:'not_analyzed'
                       # },
                     }
                            
            indexes :keywords, 
                     analyzer: 'keyword' #:not_analyzed
                     # boost:2.0
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
      length:50,
      omission:'...', 
      separator: ' '
    }.merge(truncate_options))
  end
  
  # def dont_stem(*terms)
  #   (BOOKS_OF_THE_BIBLE | terms).map(&:downcase).uniq
  # end
end