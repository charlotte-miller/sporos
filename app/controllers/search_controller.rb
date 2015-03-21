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
        # if query.length > 3
        # - update this with {}.merge
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
        # end
        },
        # filter expires_at lt Time.now
        # sort:{
        #   last_published_at:{ order:'desc' },
        #   expires_at:{ order: 'asc' },
        # },
        suggest:{
          text: query,
          
          autocomplete:{
            completion:{
              field:'keywords.autocomplete'
            }
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
