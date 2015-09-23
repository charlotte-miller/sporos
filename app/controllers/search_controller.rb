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
          multi_match:{
            query: query,
            prefix_length:2,
            type: "most_fields",
            fields:[
              "title.word_edge_ngrams",
              "keywords.autocomplete",

              "title",
              # "description",
              "keywords",

              "title.phrase_bi_grams",
              "title.phrase_tri_grams",
              "description.phrase_bi_grams",
              "description.phrase_tri_grams",

              # lesson only
              "study_title",
              "author",
            ]
          },

        #   bool: {
        #     must:{
        #       bool:{
        #         should:[
        #           { multi_match: {
        #               query: query,
        #               prefix_length:2,
        #               fields:[
        #                 :title,             # all
        #                 # :description,       # all
        #                 # :keywords,          # all
        #                 # :study_title,       # lesson
        #                 # :author,            # lesson
        #               ]
        #             }
        #           },
        #           { multi_match:{
        #               query:query,
        #               fields:[
        #                 'title.word_edge_ngrams',
        #                 # 'keywords.autocomplete',
        #                 # 'description.word_edge_ngrams'
        #               ]
        #             }
        #           },
        #         ]
        #       }
        #     },
        #     should:{
        #       multi_match: {
        #         query: query,
        #         fields:[
        #           'title.phrase_bi_grams',
        #           'title.phrase_tri_grams',
        #           'description.phrase_bi_grams',
        #         ]
        #       }
        #     }
        #   }
        # # end
        },
        # filter expired_at lt Time.now
        # sort:{
        #   last_published_at:{ order:'desc' },
        #   expired_at:{ order: 'asc' },
        # },

        # highlight:{
        #   fields:{
        #     title:{},
        #     # study_title:{},
        #     # description:{},
        #     # author:{},
        #     'title.word_edge_ngrams'=>{},
        #     'title.phrase_bi_grams'=>{},
        #     'title.phrase_tri_grams'=>{},
        #     # 'description.phrase_bi_grams'=>{},
        #   }
        # },

        aggs: {
          type_counts: { terms:{ field:'_type' }}
        },
        _source: [:title, :preview, :path],
      }.merge(pagination_options)
    })

    filtered_results = {
      took: @results['took'],
      hits: @results['hits'],
      suggest: @results['suggest'],
      total_counts: total_counts,
    }

    render json: MultiJson.dump(filtered_results, pretty:false)
  end

  def preload
    @results = Elasticsearch::Model.client.search({
      index: AppConfig.elasticsearch.index_name,
      type: types_w_defaults,
      _source: [:title, :path], # :preview,
      body:{
        size:200,
        query:{match_all:{}}
      }
    })

    filtered_results = {
      took: @results['took'],
      hits: @results['hits'],
      # suggest: @results['suggest'],
      # total_counts: total_counts,
    }

    render json: MultiJson.dump(filtered_results, pretty:false)
  rescue Faraday::TimeoutError
    render json: MultiJson.dump({error:'timeout', took:0, hits:[]}, pretty:false)
  end

  # POST search/conversion
  def conversion
  end

  # POST search/abandonment
  def abandonment
  end


private
  def search_params
    # params.require(:q)
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

  def total_counts
    hash_w_total = {total:@results['hits']['total']}
    if @results['aggregations']
      @results['aggregations']['type_counts']['buckets'].inject(hash_w_total) do |hash,obj|
        hash[obj['key']]= obj['doc_count']; hash
      end
    end
  end
end
