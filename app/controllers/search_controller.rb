class SearchController < ApplicationController
  include ElasticsearchHelpers
  
  def index
    # results = Page.search(query, {
    #   index:'content',
    #   type:[:page,:media],
    #   # fields:[:title,:path],
    # }).map(&:as_json)
    
    results = Elasticsearch::Model.client.search({
      index: AppConfig.elasticsearch.index_name,
      type: types_w_defaults,
      body: { 
        query: {
          multi_match: { 
            query: query,
            fields:[
              :title,             # all
              :description,       # all
              :keywords,          # all
              :study_title,       # lesson
              :author,            # lesson
            ]
          } 
        },
        # filter expires_at lt Time.now
        # sort:{
        #   last_published_at:{ order:'desc' },
        #   expires_at:{ order: 'asc' },
        # },
        # suggest:{
        #
        # },
        highlight:{
          fields:{
            title:{}, 
            study_title:{},
            description:{},
            author:{}
          }
        },
        aggs: {
          type_counts: { terms:{ field:'_type' }}
        },
        _source: [:title, :display_description, :path],
      }.merge(pagination_options)
    })
    
    render json: MultiJson.dump(results, pretty:true)
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
    params.permit(:types, :page)
  end
  
  def query
    q = params[:q] || ''
    # q = ActionController::Base.helpers.strip_tags( q )
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
