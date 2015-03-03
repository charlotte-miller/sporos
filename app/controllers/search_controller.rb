class SearchController < ApplicationController
  include ElasticsearchHelpers
  
  def index
    results = Page.search(query, {
      index:'content', 
      type:[:page,:media], 
      # fields:[:title,:path],
    }).map(&:as_json)
    
    # results = Elasticsearch::Model.client.search({
    #   index: 'content', #media,events
    #   type:'page',
    #   q: query
      # body: { query: { match: { title: query } },
              # facets: { tags: { terms: { field: 'tags' } } }
      # }
    # })
    
    render json: Oj.dump(results)
  end
  
  # POST search/conversion
  def conversion
  end
  
  # POST search/abandonment
  def abandonment
  end
  

private
  def query
    q = params[:q] || ''
    q = ActionController::Base.helpers.strip_tags( q )
    q = ElasticsearchHelpers.sanitize_string( q )
  end
  
end
