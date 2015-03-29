#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Video extends SearchNamespace.AbstractSource

  defaults:
    name:   'video'
    elasticsearch: true
    remote:
      url: 'http://localhost:3000/search?q=%QUERY&types=video'
      filter: @elasticsearchProcessor('video')
      
SearchNamespace.Sources.Video.setup()