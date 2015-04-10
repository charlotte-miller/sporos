#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Music extends SearchNamespace.AbstractSource

  defaults:
    name:   'music'
    elasticsearch: true
    remote:
      url: "http://#{CStoneData.domains.origin}/search?q=%QUERY&types=music"
      filter: @elasticsearchProcessor('music')
      
SearchNamespace.Sources.Music.setup()