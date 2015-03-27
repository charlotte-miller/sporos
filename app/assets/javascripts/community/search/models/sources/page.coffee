#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Page extends SearchNamespace.AbstractSource

  defaults:
    name:   'page'
    elasticsearch: true
    remote:
      url: 'http://localhost:3000/search?q=%QUERY&types=page'
      filter: @elasticsearchProcessor('page')

  
SearchNamespace.Sources.Page.setup()