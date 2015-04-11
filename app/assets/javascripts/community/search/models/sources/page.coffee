#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Page extends SearchNamespace.AbstractSource

  defaults:
    name:   'page'
    elasticsearch: true
    prefetch: 
      url: "http://#{CStoneData.domains.origin}/search/preload?types=page"
      filter: @elasticsearchProcessor('page')
    remote:
      url: "http://#{CStoneData.domains.origin}/search?q=%QUERY&types=page"
      filter: @elasticsearchProcessor('page')

  
SearchNamespace.Sources.Page.setup()