#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Page extends SearchNamespace.AbstractSource

  defaults:
    name:   'page'
    remote:
      url: 'http://localhost:3000/search?q=%QUERY&types=page'
      filter: @helpers.elasticsearchResultProcessor('page')
  
SearchNamespace.Sources.Page.setup()