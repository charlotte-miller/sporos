class SearchController < ApplicationController
  include ElasticsearchHelpers
  
  def index    
    @results = Elasticsearch::Model.client.search({
      index: AppConfig.elasticsearch.index_name,
      type: types_w_defaults,
      # explain:true,
      # search_type:'count', #w/out hits
      body: { 
        query: {
          bool: {
            must:{
              bool:{
                should:[
                  { multi_match: { 
                      query: query,
                      # fuzziness:'AUTO',
                      # prefix_length:3,
                      fields:[
                        :title,             # all
                        :description,       # all
                        :keywords,          # all
                        :study_title,       # lesson
                        :author,            # lesson
                      ]
                    }
                  },
                  { multi_match:{
                      query:query,
                      fields:[
                        'title.word_edge_ngrams',
                        'description.word_edge_ngrams'
                      ]
                    }
                  },
                ]
              }
            },
            should:{
              multi_match: { 
                query: query,
                fields:[
                  'title.phrase_bi_grams',
                  'title.phrase_tri_grams',
                  'description.phrase_bi_grams',
                ]
              }
            }
          }
        },
        # filter expires_at lt Time.now
        # sort:{
        #   last_published_at:{ order:'desc' },
        #   expires_at:{ order: 'asc' },
        # },
        suggest:{
          text: query,
          # words:{
          #   term:{
          #     field:'title',             # pretty bad
          #     size:3,
          #     sort:'score', #frequency
          #     suggest_mode:'popular'
          #   }
          # },
          
          # Use fuzzy instead
          # spelling:{
          #   phrase:{
          #     # analyzer:'standard',
          #     field:'description',
          #     size:3,
          #     real_word_error_likelihood:0.95,
          #     max_errors:0.5,
          #     gram_size: 2,
          #     direct_generator:[{
          #       field:'description',
          #       suggest_mode:'popular',
          #       min_word_length:1,
          #     }],
          #     highlight:{
          #       pre_tag:'<em>',
          #       post_tag:'</em>'
          #     },
          #   },
          # },
          
          autocomplete:{
            #TODO
          },
        },
        highlight:{
          fields:{
            title:{}, 
            study_title:{},
            description:{},
            author:{},
            'title.word_edge_ngrams'=>{},
            'description.word_edge_ngrams'=>{},
          }
        },
        aggs: {
          type_counts: { terms:{ field:'_type' }}
        },
        _source: [:title, :display_description, :path],
      }.merge(pagination_options)
    })
    
    render json: MultiJson.dump(@results, pretty:false)
  end
  
  # POST search/conversion
  def conversion
  end
  
  # POST search/abandonment
  def abandonment
  end
  

private
  def search_params
    params.require(:q)
    @search_params ||= params.permit(:q, :types, :page)
  end
  
  def query
    q = search_params[:q]
    q = q[0...80] #cap at 50 char
    # q = ElasticsearchHelpers.sanitize_string( q )
  end
  
  def types_w_defaults
    search_params[:types] || nil
  end
  
  def pagination_options
    return {} unless search_params[:page]
    
    page_size = 10
    result_count = page_size * search_params[:page]
    {
      size: page_size,
      from: result_count
    }
  end
end
