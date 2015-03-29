#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Sermon extends SearchNamespace.AbstractSource

  defaults:
    name:   'sermon'
    elasticsearch: true
    remote:
      url: 'http://localhost:3000/search?q=%QUERY&types=sermon'
      filter: @elasticsearchProcessor('sermon')
    
    
SearchNamespace.Sources.Sermon.setup()